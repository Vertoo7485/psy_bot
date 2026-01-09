# app/services/telegram/handlers/self_help_handlers/day_handlers/day_2_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day2Handler < BaseHandler
          # Паттерн для всех callback'ов дня 2
          CALLBACK_PATTERN = /^(start_day_2_|continue_day_2_|day_2_)/
          
          def process
            log_info("Processing Day 2 callback: #{@callback_data}")
            
            # Создаем сервис Дня 2
            day_service = SelfHelp::Days::Day2Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_2_from_proposal', 'start_day_2_content'
              handle_day_start(day_service)
            when 'continue_day_2_content'
              handle_day_continue(day_service)
            else
              # Все специфичные кнопки дня 2 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day2Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_start(day_service)
            log_info("Starting Day 2 from scratch for user #{@user.telegram_id}")
            
            # Проверяем, завершен ли день 1 (ИСПРАВЛЕНО!)
            unless @user.completed_days&.include?(1)
              answer_callback_query("❌ Сначала завершите День 1")
              return
            end
            
            # Проверяем ограничения времени
            can_start_result = @user.can_start_day?(2)
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              log_warn("User cannot start day 2", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            # 1. Очищаем данные дня 2
            clear_day_2_data
            
            # 2. Начинаем день в системе отслеживания
            @user.start_day_program(2)
            
            # 3. Устанавливаем начальное состояние
            @user.set_self_help_step("day_2_intro")
            
            # 4. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 5. Отвечаем на callback
            answer_callback_query("🧘 Начинаем День 2: Сканирование тела!")
          end
          
          def clear_day_2_data
            # Очищаем данные дня 2 из self_help_program_data
            log_info("Clearing Day 2 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(2)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_2_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 2 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 2 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 2
            if @user.self_help_state&.include?("day_2")
              # Если пользователь на последнем шаге (intro), переходим к следующему
              if @user.self_help_state == "day_2_intro"
                # Сначала обновляем состояние, чтобы отметить, что intro пройден
                @user.set_self_help_step("day_2_exercise_in_progress")
                # Затем показываем следующий шаг
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 2!")
            else
              # Если не в дне 2, начинаем заново
              log_warn("User not in day 2 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 2 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day2Service
            # (выбор формата медитации, таймер, рефлексия и т.д.)
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day2Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day2Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day2Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end