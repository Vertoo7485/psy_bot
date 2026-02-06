# app/services/telegram/handlers/self_help_handlers/day_handlers/day18_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day18Handler < BaseHandler
          def process
            log_info("Processing Day 18 callback: #{@callback_data}")
            
            # Создаем сервис Дня 18
            day_service = SelfHelp::Days::Day18Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_18_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_18_exercise'
              # Это кнопка "Начать упражнение" на экране интро
              handle_exercise_start(day_service)
            when 'view_pleasure_activities', 'back_to_day_18_menu'
              # Эти действия делегируем сервису
              handle_day_specific_button(day_service)
            else
              # Все специфичные кнопки дня 18 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day18Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day18Handler.handle_day_start called for start_day_18_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 18 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 17
            unless @user.completed_days&.include?(17)
              Rails.logger.debug "[DEBUG] Day 17 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 17")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(18) for start_day_18_from_proposal..."
            can_start_result = @user.can_start_day?(18)
            Rails.logger.debug "[DEBUG] can_start_day?(18) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(18) failed: #{error_message}"
              log_warn("User cannot start day 18 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(18) passed, proceeding..."
            
            # 3. Очищаем данные дня 18
            clear_day_18_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 18)"
            @user.start_day_program(18)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_18_intro")
            
            # 6. Запускаем введение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("🌟 Начинаем День 18: Время для себя и своих интересов!")
            Rails.logger.debug "[DEBUG] Day 18 started successfully from proposal"
          end
          
          def handle_exercise_start(day_service)
  Rails.logger.debug "[DEBUG] Day18Handler.handle_exercise_start called for start_day_18_exercise"
  Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
  
  log_info("Starting Day 18 exercise for user #{@user.telegram_id}")
  
  # Проверяем, что пользователь уже в состоянии day_18_intro
  if @user.self_help_state == "day_18_intro"
    Rails.logger.debug "[DEBUG] User in day_18_intro state, proceeding to exercise"
    
    # 1. Обновляем состояние
    @user.set_self_help_step("day_18_exercise_in_progress")
    
    # 2. Запускаем упражнение через сервис
    day_service.deliver_exercise
    
    # 3. Отвечаем на callback
    answer_callback_query("Начинаем упражнение дня 18!")
  else
    # Если пользователь не в состоянии day_18_intro, но хочет начать новую активность
    # из меню после завершения дня
    Rails.logger.debug "[DEBUG] User wants to start new activity, checking if day completed"
    
    # Проверяем, завершен ли день
    if @user.completed_days&.include?(18)
      # День завершен, можно начать новую активность
      @user.set_self_help_step("day_18_exercise_in_progress")
      day_service.deliver_exercise
      answer_callback_query("Начинаем новую активность!")
    else
      # День не завершен, проверяем можно ли начать
      handle_day_start(day_service)
    end
  end
end
          
          def clear_day_18_data
            # Очищаем данные дня 18 из self_help_program_data
            log_info("Clearing Day 18 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(18)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_18_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 18 data to clear")
              end
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 18 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day18Service
            day_service.handle_button(@callback_data)
            
            # Отвечаем на callback_query (если не ответил сам сервис)
            answer_callback_query("Обрабатываю...")
          end
          
          def log_info(message)
            Rails.logger.info "[Day18Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day18Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day18Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end