# app/services/telegram/handlers/self_help_handlers/day_handlers/day27_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day27Handler < BaseHandler
          # Паттерн для всех callback'ов дня 27
          CALLBACK_PATTERN = /^(start_day_27_|continue_day_27_|day_27_)/
          
          def process
            log_info("Processing Day 27 callback: #{@callback_data}")
            
            # Создаем сервис Дня 27
            day_service = SelfHelp::Days::Day27Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_27_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_27_content'
              # Это кнопка "Начать практику" на экране интро
              handle_intro_continue(day_service)
            when 'continue_day_27_content'
              handle_day_continue(day_service)
            when 'day_27_exercise_completed', 'day_27_complete_exercise'
              handle_exercise_completion(day_service)
            else
              # Все специфичные кнопки дня 27 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day27Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day27Handler.handle_day_start called for start_day_27_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 27 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 26
            unless @user.completed_days&.include?(26)
              Rails.logger.debug "[DEBUG] Day 26 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 26")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(27) for start_day_27_from_proposal..."
            can_start_result = @user.can_start_day?(27)
            Rails.logger.debug "[DEBUG] can_start_day?(27) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(27) failed: #{error_message}"
              log_warn("User cannot start day 27 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(27) passed, proceeding..."
            
            # 3. Очищаем данные дня 27
            clear_day_27_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 27)"
            @user.start_day_program(27)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_27_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("🧠 Начинаем День 27: Нейрохакинг радости!")
            Rails.logger.debug "[DEBUG] Day 27 started successfully from proposal"
          end
          
          def handle_intro_continue(day_service)
            Rails.logger.debug "[DEBUG] Day27Handler.handle_intro_continue called for start_day_27_content"
            Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
            
            log_info("Continuing Day 27 from intro for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь уже в состоянии day_27_intro
            if @user.self_help_state == "day_27_intro"
              Rails.logger.debug "[DEBUG] User in day_27_intro state, proceeding to exercise"
              
              # 1. Обновляем состояние
              @user.set_self_help_step("day_27_exercise_in_progress")
              
              # 2. Запускаем упражнение через сервис
              day_service.deliver_exercise
              
              # 3. Отвечаем на callback
              answer_callback_query("Продолжаем практику нейрохакинга радости!")
            else
              # Если пользователь не в состоянии day_27_intro, проверяем можно ли начать день
              Rails.logger.warn("[DEBUG] User not in day_27_intro state, checking if can start day")
              log_warn("User not in intro state, checking if can start day", state: @user.self_help_state)
              
              # Если день еще не начат, начинаем его
              handle_day_start(day_service)
            end
          end
          
          def clear_day_27_data
            # Очищаем данные дня 27 из self_help_program_data
            log_info("Clearing Day 27 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(27)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_27_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 27 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 27 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 27
            if @user.self_help_state&.include?("day_27")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_27_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 27!")
            else
              # Если не в дне 27, начинаем заново
              log_warn("User not in day 27 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_exercise_completion(day_service)
            log_info("Completing Day 27 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь в процессе дня 27
            if @user.self_help_state&.include?("day_27")
              day_service.complete_exercise
              answer_callback_query("✅ Упражнение дня 27 завершено!")
            else
              log_warn("User not in day 27 exercise state", state: @user.self_help_state)
              answer_callback_query("Сначала начните День 27")
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 27 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day27Service
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day27Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day27Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day27Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end