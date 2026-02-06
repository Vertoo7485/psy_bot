module Telegram
  module Handlers
    module SelfHelpHandlers
      class Day24Handler < BaseHandler
        def process
          log_info("Processing day 24 callback: #{@callback_data} - User: #{@user.telegram_id}, Chat: #{@chat_id}")
          
          begin
            day_service = SelfHelp::Days::Day24Service.new(bot_service, user, chat_id)
            day_service.handle_button(@callback_data)
            
          rescue => e
            log_error("Error in Day24Service processing", e)
            send_message(
              text: "Произошла ошибка при выполнении упражнения. Пожалуйста, попробуйте еще раз."
            )
            answer_callback_query( "❌ Ошибка")
            return
          end
          
          answer_callback_query( "✅")
        end
        
        private
        
        def send_message(text:, reply_markup: nil, parse_mode: nil)
          @bot_service.send_message(
            chat_id: @chat_id,
            text: text,
            reply_markup: reply_markup,
            parse_mode: parse_mode
          )
        rescue => e
          log_error("Failed to send message", e)
        end
      end
    end
  end
end# app/services/telegram/handlers/self_help_handlers/day_handlers/day24_handler.rb

module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day24Handler < BaseHandler
          # Паттерн для всех callback'ов дня 24
          CALLBACK_PATTERN = /^(start_day_24_|continue_day_24_|day_24_|retry_day_24_|complete_day_24)/
          
          def process
            log_info("Processing Day 24 callback: #{@callback_data} - User: #{@user.telegram_id}")
            
            # Создаем сервис Дня 24
            day_service = SelfHelp::Days::Day24Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_24_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_24_content', 'start_day_24_exercise'
              # Это кнопка "Начать упражнение" на экране интро
              handle_intro_continue(day_service)
            when 'continue_day_24_content'
              handle_day_continue(day_service)
            when 'retry_day_24_exercise'
              # Это повторное прохождение дня - БЕЗ ПРОВЕРОК
              handle_day_retry(day_service)
            when 'day_24_complete_exercise'
              handle_exercise_completion(day_service)
            else
              # Все специфичные кнопки дня 24 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day24Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_retry(day_service)
            log_info("Retrying Day 24 exercise for user #{@user.telegram_id}")
            
            # 1. Очищаем данные дня 24
            clear_day_24_data
            
            # 2. Устанавливаем состояние интро (без проверок времени и завершения)
            @user.set_self_help_step("day_24_intro")
            
            # 3. Очищаем данные self_help_program_data для дня 24
            clear_self_help_day_data
            
            # 4. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 5. Отвечаем на callback
            answer_callback_query("🔄 Начинаем День 24 заново!")
          end
          
          def clear_self_help_day_data
            # Очищаем только данные дня 24 в self_help_program_data
            data = @user.read_attribute(:self_help_program_data) || {}
            
            if data.is_a?(Hash)
              keys_to_delete = data.keys.select do |key|
                key.to_s.start_with?('day_24_')
              end
              
              keys_to_delete.each do |key|
                data.delete(key)
              end
              
              if data != @user.read_attribute(:self_help_program_data)
                @user.update(self_help_program_data: data)
                log_info("Cleared self_help_program_data keys: #{keys_to_delete}")
              end
            end
          end
          
          def handle_day_start(day_service)
  log_info("Starting Day 24 from proposal for user #{@user.telegram_id}")
  
  # ПРОВЕРКА 0: Если пользователь уже в процессе дня 24, продолжаем, а не начинаем заново
  if @user.self_help_state&.include?("day_24")
    log_info("User already in day 24 state: #{@user.self_help_state}. Continuing instead of restarting.")
    
    # Если пользователь только на интро-экране, начинаем упражнение
    if @user.self_help_state == "day_24_intro"
      handle_intro_continue(day_service)
    else
      # Иначе продолжаем с того места, где остановились
      handle_day_continue(day_service)
    end
    return
  end
  
  # Остальной код остается как есть...
  # 1. Проверяем, завершен ли день 23
  unless @user.completed_days&.include?(23)
    answer_callback_query("❌ Сначала завершите День 23")
    return
  end
  
  # 2. Проверяем ограничения времени
  can_start_result = @user.can_start_day?(24)
  
  if can_start_result != true
    error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
    log_warn("User cannot start day 24 from proposal", reason: error_message)
    answer_callback_query(error_message)
    return
  end
  
  # 3. Очищаем данные дня 24
  clear_day_24_data
  
  # 4. Начинаем день в системе отслеживания
  @user.start_day_program(24)
  
  # 5. Устанавливаем начальное состояние
  @user.set_self_help_step("day_24_intro")
  
  # 6. Запускаем упражнение через сервис
  day_service.deliver_intro
  
  # 7. Отвечаем на callback
  answer_callback_query("🛡️ Начинаем День 24: Предвосхищение!")
end
          
          def handle_intro_continue(day_service)
  log_info("Continuing Day 24 from intro for user #{@user.telegram_id}")
  
  # Проверяем, что пользователь в процессе дня 24
  if @user.self_help_state&.include?("day_24")
    # Если пользователь на интро, переходим к упражнению
    if @user.self_help_state == "day_24_intro"
      @user.set_self_help_step("day_24_exercise_in_progress")
      day_service.deliver_exercise
      answer_callback_query("Начинаем упражнение предвосхищения!")
    else
      # Если уже в процессе упражнения, продолжаем
      handle_day_continue(day_service)
    end
  else
    # Если пользователь не в дне 24, начинаем его
    log_warn("User not in day 24 state, starting fresh", state: @user.self_help_state)
    handle_day_start(day_service)
  end
end
          
          def clear_day_24_data
            # Очищаем данные дня 24 из self_help_program_data
            log_info("Clearing Day 24 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(24)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              data = @user.read_attribute(:self_help_program_data) || {}
              day_data_keys = data.keys.select { |k| k.to_s.start_with?('day_24_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  data.delete(key)
                end
                @user.update(self_help_program_data: data)
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 24 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 24 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 24
            if @user.self_help_state&.include?("day_24")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_24_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 24!")
            else
              # Если не в дне 24, начинаем заново
              log_warn("User not in day 24 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_exercise_completion(day_service)
            log_info("Completing Day 24 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь в процессе дня 24
            if @user.self_help_state&.include?("day_24")
              day_service.complete_exercise
              answer_callback_query("✅ Упражнение дня 24 завершено!")
            else
              log_warn("User not in day 24 exercise state", state: @user.self_help_state)
              answer_callback_query("Сначала начните День 24")
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 24 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day24Service
            if day_service.respond_to?(:handle_button)
              day_service.handle_button(@callback_data)
            else
              log_error("Day24Service doesn't have handle_button method")
              answer_callback_query("Ошибка обработки кнопки")
            end
          end
          
          # Унаследованный метод для отправки сообщений
          def send_message(text:, reply_markup: nil, parse_mode: nil)
            @bot_service.send_message(
              chat_id: @chat_id,
              text: text,
              reply_markup: reply_markup,
              parse_mode: parse_mode
            )
          rescue => e
            log_error("Failed to send message", e)
          end
          
          def log_info(message)
            Rails.logger.info "[Day24Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day24Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day24Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end