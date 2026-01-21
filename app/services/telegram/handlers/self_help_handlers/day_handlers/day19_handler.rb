# app/services/telegram/handlers/self_help_handlers/day_handlers/day19_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day19Handler < BaseHandler
          def process
  log_info("Processing Day 19 callback: #{@callback_data}")
  
  # Создаем сервис Дня 19
  day_service = SelfHelp::Days::Day19Service.new(@bot_service, @user, @chat_id)
  
  # Определяем тип действия
  case @callback_data
  when 'start_day_19_from_proposal'
    # Это начало дня из предложения (из программы)
    handle_day_start(day_service)
  when 'start_day_19_exercise'
    # Это кнопка "Начать упражнение" на экране интро
    handle_exercise_start(day_service)
  else
    # Все остальные кнопки дня 19 делегируем сервису
    handle_day_specific_button(day_service)
  end
  
rescue => e
  log_error("Error in Day19Handler", e)
  answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
end
          
          private
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day19Handler.handle_day_start called for start_day_19_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 19 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 18
            unless @user.completed_days&.include?(18)
              Rails.logger.debug "[DEBUG] Day 18 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 18")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(19) for start_day_19_from_proposal..."
            can_start_result = @user.can_start_day?(19)
            Rails.logger.debug "[DEBUG] can_start_day?(19) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(19) failed: #{error_message}"
              log_warn("User cannot start day 19 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(19) passed, proceeding..."
            
            # 3. Очищаем данные дня 19
            clear_day_19_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 19)"
            @user.start_day_program(19)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_19_intro")
            
            # 6. Запускаем введение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("🧘‍♀️ Начинаем День 19: Ваша первая медитация!")
            Rails.logger.debug "[DEBUG] Day 19 started successfully from proposal"
          end
          
          def handle_exercise_start(day_service)
            Rails.logger.debug "[DEBUG] Day19Handler.handle_exercise_start called for start_day_19_exercise"
            Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
            
            log_info("Starting Day 19 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь уже в состоянии day_19_intro
            if @user.self_help_state == "day_19_intro"
              Rails.logger.debug "[DEBUG] User in day_19_intro state, proceeding to exercise"
              
              # 1. Обновляем состояние
              @user.set_self_help_step("day_19_exercise_in_progress")
              
              # 2. Запускаем упражнение через сервис
              day_service.deliver_exercise
              
              # 3. Отвечаем на callback
              answer_callback_query("Начинаем медитацию!")
            else
              # Если пользователь не в состоянии day_19_intro, но хочет начать новую медитацию
              # из меню после завершения дня
              Rails.logger.debug "[DEBUG] User wants to start new meditation, checking if day completed"
              
              # Проверяем, завершен ли день
              if @user.completed_days&.include?(19)
                # День завершен, можно начать новую медитацию
                @user.set_self_help_step("day_19_exercise_in_progress")
                day_service.deliver_exercise
                answer_callback_query("Начинаем новую медитацию!")
              else
                # День не завершен, проверяем можно ли начать
                handle_day_start(day_service)
              end
            end
          end
          
          def clear_day_19_data
            # Очищаем данные дня 19 из self_help_program_data
            log_info("Clearing Day 19 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(19)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_19_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 19 data to clear")
              end
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 19 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day19Service
            day_service.handle_button(@callback_data)
            
            # Отвечаем на callback_query (если не ответил сам сервис)
            answer_callback_query("Обрабатываю...")
          end
          
          def log_info(message)
            Rails.logger.info "[Day19Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day19Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day19Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end