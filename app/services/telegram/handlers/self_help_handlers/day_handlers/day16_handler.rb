# app/services/telegram/handlers/self_help_handlers/day_handlers/day16_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day16Handler < BaseHandler
          # Паттерн для всех callback'ов дня 16
          CALLBACK_PATTERN = /^(start_day_16_|continue_day_16_|day_16_|reconnection_exercise_completed|start_reconnection_exercise|view_reconnection_history|reconnection_stats)/
          
          def process
            log_info("Processing Day 16 callback: #{@callback_data}")
            
            # Создаем сервис Дня 16
            day_service = SelfHelp::Days::Day16Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_16_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_16_content', 'start_reconnection_exercise'
              # Это кнопка "Начать практику" на экране интро
              handle_intro_continue(day_service)
            when 'continue_day_16_content'
              handle_day_continue(day_service)
            when 'day_16_exercise_completed', 'reconnection_exercise_completed'
              # Завершение упражнения
              handle_exercise_completion(day_service)
            when /^day_16_challenge_(\d+)$/
              day_service.handle_challenge_selection($1)
            when 'day_16_start_new_practice'
              handle_new_practice_start(day_service)
            when 'view_reconnection_history', 'reconnection_stats'
              handle_history_and_stats(day_service)
            else
              # Все специфичные кнопки дня 16 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day16Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_new_practice_start(day_service)
            log_info("Starting new reconnection practice for user #{@user.telegram_id}")
            
            # Очищаем данные предыдущей практики, но НЕ начинаем день заново
            clear_day_16_data
            
            # Устанавливаем состояние для новой практики
            @user.set_self_help_step("day_16_exercise_in_progress")
            
            # Начинаем новую практику
            day_service.deliver_exercise
            
            answer_callback_query("🔄 Начинаем новую практику восстановления связей!")
          end
          
          def handle_history_and_stats(day_service)
            case @callback_data
            when 'view_reconnection_history'
              day_service.show_previous_practices
              answer_callback_query("📚 Показываю ваши восстановленные связи")
            when 'reconnection_stats'
              day_service.show_reconnection_stats
              answer_callback_query("📊 Показываю статистику")
            end
          end
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day16Handler.handle_day_start called for start_day_16_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 16 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 15
            unless @user.completed_days&.include?(15)
              Rails.logger.debug "[DEBUG] Day 15 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 15")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(16) for start_day_16_from_proposal..."
            can_start_result = @user.can_start_day?(16)
            Rails.logger.debug "[DEBUG] can_start_day?(16) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(16) failed: #{error_message}"
              log_warn("User cannot start day 16 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(16) passed, proceeding..."
            
            # 3. Очищаем данные дня 16
            clear_day_16_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 16)"
            @user.start_day_program(16)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_16_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("🤝 Начинаем День 16: Восстановление связей!")
            Rails.logger.debug "[DEBUG] Day 16 started successfully from proposal"
          end
          
          def handle_intro_continue(day_service)
            Rails.logger.debug "[DEBUG] Day16Handler.handle_intro_continue called for start_day_16_content"
            Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
            
            log_info("Continuing Day 16 from intro for user #{@user.telegram_id}")
            
            case @user.self_help_state
            when "day_16_intro"
              Rails.logger.debug "[DEBUG] User in day_16_intro state, proceeding to exercise"
              
              # Начало упражнения из intro
              @user.set_self_help_step("day_16_exercise_in_progress")
              day_service.deliver_exercise
              answer_callback_query("Продолжаем практику восстановления связей!")
              
            when "day_16_reflection_done"
              Rails.logger.debug "[DEBUG] User completed reflection, offering options"
              
              # Пользователь завершил рефлексию - предлагаем выбор
              send_message(
                text: "🎯 Вы уже завершили практику восстановления связей.\n\nЧто вы хотите сделать?",
                reply_markup: {
                  inline_keyboard: [
                    [
                      { text: "✅ Завершить День 16", callback_data: 'day_16_complete_exercise' },
                      { text: "🔄 Новая практика", callback_data: 'day_16_start_new_practice' }
                    ]
                  ]
                }
              )
              
              answer_callback_query("Выберите действие")
              
            when nil, ""
              # Пользователь не в дне 16 - начинаем день с проверкой ограничений
              handle_day_start(day_service)
              
            else
              # Любое другое состояние дня 16 - продолжаем сессию
              Rails.logger.debug("[DEBUG] User in day 16 state: #{@user.self_help_state}")
              day_service.resume_session
              answer_callback_query("🔄 Возвращаемся к практике дня 16!")
            end
          end
          
          def clear_day_16_data
            # Очищаем данные дня 16 из self_help_program_data
            log_info("Clearing Day 16 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(16)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_16_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 16 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 16 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 16
            if @user.self_help_state&.include?("day_16")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_16_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 16!")
            else
              # Если не в дне 16, начинаем заново
              log_warn("User not in day 16 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_exercise_completion(day_service)
            log_info("Completing Day 16 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь в процессе дня 16
            if @user.self_help_state&.include?("day_16")
              day_service.complete_exercise
              answer_callback_query("✅ Упражнение дня 16 завершено!")
            else
              log_warn("User not in day 16 exercise state", state: @user.self_help_state)
              answer_callback_query("Сначала начните День 16")
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 16 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day16Service
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day16Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day16Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day16Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end