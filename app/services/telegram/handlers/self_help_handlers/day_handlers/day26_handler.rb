# app/services/telegram/handlers/self_help_handlers/day_handlers/day26_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day26Handler < BaseHandler
          # Паттерн для всех callback'ов дня 26
          CALLBACK_PATTERN = /^(start_day_26_|continue_day_26_|day_26_)/
          
          def process
            log_info("Processing Day 26 callback: #{@callback_data}")
            
            # Создаем сервис Дня 26
            day_service = SelfHelp::Days::Day26Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_26_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_26_content'
              # Это кнопка "Начать практику" на экране интро
              handle_intro_continue(day_service)
            when 'continue_day_26_content'
              handle_day_continue(day_service)
            when 'day_26_exercise_completed', 'day_26_complete_exercise'
              handle_exercise_completion(day_service)
            else
              # Все специфичные кнопки дня 26 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day26Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day26Handler.handle_day_start called for start_day_26_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 26 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 25
            unless @user.completed_days&.include?(25)
              Rails.logger.debug "[DEBUG] Day 25 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 25")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(26) for start_day_26_from_proposal..."
            can_start_result = @user.can_start_day?(26)
            Rails.logger.debug "[DEBUG] can_start_day?(26) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(26) failed: #{error_message}"
              log_warn("User cannot start day 26 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(26) passed, proceeding..."
            
            # 3. Очищаем данные дня 26
            clear_day_26_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 26)"
            @user.start_day_program(26)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_26_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("🔗 Начинаем День 26: Цепочка ценностей!")
            Rails.logger.debug "[DEBUG] Day 26 started successfully from proposal"
          end
          
          def handle_intro_continue(day_service)
            Rails.logger.debug "[DEBUG] Day26Handler.handle_intro_continue called for start_day_26_content"
            Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
            
            log_info("Continuing Day 26 from intro for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь уже в состоянии day_26_intro
            if @user.self_help_state == "day_26_intro"
              Rails.logger.debug "[DEBUG] User in day_26_intro state, proceeding to exercise"
              
              # 1. Обновляем состояние
              @user.set_self_help_step("day_26_exercise_in_progress")
              
              # 2. Запускаем упражнение через сервис
              day_service.deliver_exercise
              
              # 3. Отвечаем на callback
              answer_callback_query("Продолжаем практику цепочки ценностей!")
            else
              # Если пользователь не в состоянии day_26_intro, проверяем можно ли начать день
              Rails.logger.warn("[DEBUG] User not in day_26_intro state, checking if can start day")
              log_warn("User not in intro state, checking if can start day", state: @user.self_help_state)
              
              # Если день еще не начат, начинаем его
              handle_day_start(day_service)
            end
          end
          
          def clear_day_26_data
            # Очищаем данные дня 26 из self_help_program_data
            log_info("Clearing Day 26 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(26)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_26_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 26 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 26 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 26
            if @user.self_help_state&.include?("day_26")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_26_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 26!")
            else
              # Если не в дне 26, начинаем заново
              log_warn("User not in day 26 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_exercise_completion(day_service)
            log_info("Completing Day 26 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь в процессе дня 26
            if @user.self_help_state&.include?("day_26")
              day_service.complete_exercise
              answer_callback_query("✅ Упражнение дня 26 завершено!")
            else
              log_warn("User not in day 26 exercise state", state: @user.self_help_state)
              answer_callback_query("Сначала начните День 26")
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 26 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day26Service
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day26Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day26Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day26Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end