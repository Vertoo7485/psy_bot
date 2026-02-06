# app/services/telegram/handlers/self_help_handlers/day_handlers/day15_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day15Handler < BaseHandler
          # Паттерн для всех callback'ов дня 15
          CALLBACK_PATTERN = /^(start_day_15_|continue_day_15_|day_15_|kindness_exercise_completed|start_kindness_exercise)/
          
          def process
            log_info("Processing Day 15 callback: #{@callback_data}")
            
            # Создаем сервис Дня 15
            day_service = SelfHelp::Days::Day15Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_15_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_15_content', 'start_kindness_exercise'
              # Это кнопка "Начать практику" на экране интро
              handle_intro_continue(day_service)
            when 'continue_day_15_content'
              handle_day_continue(day_service)
            when 'day_15_exercise_completed', 'kindness_exercise_completed'
              # Завершение упражнения
              handle_exercise_completion(day_service)
            when /^day_15_challenge_(\d+)$/
              day_service.handle_challenge_selection($1)
              
            when 'day_15_start_new_practice'
              handle_new_practice_start(day_service)
            else
              # Все специфичные кнопки дня 15 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day15Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_new_practice_start(day_service)
            log_info("Starting new kindness practice for user #{@user.telegram_id}")
            
            # Очищаем данные предыдущей практики, но НЕ начинаем день заново
            clear_day_15_data
            
            # Устанавливаем состояние для новой практики
            @user.set_self_help_step("day_15_exercise_in_progress")
            
            # Начинаем новую практику
            day_service.deliver_exercise
            
            answer_callback_query("🔄 Начинаем новую практику доброты!")
          end

          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day15Handler.handle_day_start called for start_day_15_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 15 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 14
            unless @user.completed_days&.include?(14)
              Rails.logger.debug "[DEBUG] Day 14 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 14")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(15) for start_day_15_from_proposal..."
            can_start_result = @user.can_start_day?(15)
            Rails.logger.debug "[DEBUG] can_start_day?(15) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(15) failed: #{error_message}"
              log_warn("User cannot start day 15 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(15) passed, proceeding..."
            
            # 3. Очищаем данные дня 15
            clear_day_15_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 15)"
            @user.start_day_program(15)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_15_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("🤝 Начинаем День 15: Акты доброты!")
            Rails.logger.debug "[DEBUG] Day 15 started successfully from proposal"
          end
          
          def handle_intro_continue(day_service)
  Rails.logger.debug "[DEBUG] Day15Handler.handle_intro_continue called for start_day_15_content"
  Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
  
  log_info("Continuing Day 15 from intro for user #{@user.telegram_id}")
  
  case @user.self_help_state
  when "day_15_intro"
    Rails.logger.debug "[DEBUG] User in day_15_intro state, proceeding to exercise"
    
    # Начало упражнения из intro
    @user.set_self_help_step("day_15_exercise_in_progress")
    day_service.deliver_exercise
    answer_callback_query("Продолжаем практику доброты!")
    
  when "day_15_reflection_done"
    Rails.logger.debug "[DEBUG] User completed reflection, offering options"
    
    # Пользователь завершил рефлексию - предлагаем выбор
    send_message(
      text: "🎯 Вы уже завершили практику доброты.\n\nЧто вы хотите сделать?",
      reply_markup: {
        inline_keyboard: [
          [
            { text: "✅ Завершить День 15", callback_data: 'day_15_complete_exercise' },
            { text: "🔄 Новая практика", callback_data: 'day_15_start_new_practice' }
          ]
        ]
      }
    )
    
    answer_callback_query("Выберите действие")
    
  when nil, ""
    # Пользователь не в дне 15 - начинаем день с проверкой ограничений
    handle_day_start(day_service)
    
  else
    # Любое другое состояние дня 15 - продолжаем сессию
    Rails.logger.debug("[DEBUG] User in day 15 state: #{@user.self_help_state}")
    day_service.resume_session
    answer_callback_query("🔄 Возвращаемся к практике дня 15!")
  end
end
          def clear_day_15_data
            # Очищаем данные дня 15 из self_help_program_data
            log_info("Clearing Day 15 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(15)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_15_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 15 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 15 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 15
            if @user.self_help_state&.include?("day_15")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_15_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 15!")
            else
              # Если не в дне 15, начинаем заново
              log_warn("User not in day 15 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_exercise_completion(day_service)
            log_info("Completing Day 15 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь в процессе дня 15
            if @user.self_help_state&.include?("day_15")
              day_service.complete_exercise
              answer_callback_query("✅ Упражнение дня 15 завершено!")
            else
              log_warn("User not in day 15 exercise state", state: @user.self_help_state)
              answer_callback_query("Сначала начните День 15")
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 15 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day15Service
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day15Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day15Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day15Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end 