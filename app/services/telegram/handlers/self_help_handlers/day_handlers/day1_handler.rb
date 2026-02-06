module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day1Handler < BaseHandler
          # Паттерн для всех callback'ов дня 1
          CALLBACK_PATTERN = /^(start_day_1_|continue_day_1_|day_1_)/
          
          def process
            log_info("Processing Day 1 callback: #{@callback_data}")
            
            # Создаем сервис Дня 1
            day_service = SelfHelp::Days::Day1Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_1_content', 'start_day_1_from_proposal'
              handle_day_start(day_service)
            when 'continue_day_1_content'
              handle_day_continue(day_service)
            else
              # Все специфичные кнопки дня 1 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day1Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_start(day_service)
            log_info("Starting Day 1 from scratch for user #{@user.telegram_id}")
            
            # Проверяем ограничения
            can_start_result = @user.can_start_day?(1)
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              log_warn("User cannot start day 1", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            # 1. Очищаем данные дня 1
            clear_day_1_data
            
            # 2. Начинаем день в системе отслеживания
            @user.start_day_program(1)
            
            # 3. Устанавливаем начальное состояние
            @user.set_self_help_step("day_1_intro")
            
            # 4. Запускаем упражнение через сервис
            day_service.deliver_exercise
            
            # 5. Отвечаем на callback
            answer_callback_query("Начинаем День 1!")
          end
          
          # Метод для очистки данных дня 1
          def clear_day_1_data
            # Используем метод clear_day_data из модели User
            if @user.respond_to?(:clear_day_data)
              cleared_keys = @user.clear_day_data(1)
              log_info("Cleared day 1 data: #{cleared_keys}") if cleared_keys.any?
            else
              # Альтернативный способ очистки
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_1_') }
              
              day_data_keys.each do |key|
                @user.self_help_program_data.delete(key)
              end
              
              if day_data_keys.any?
                @user.save
                log_info("Cleared day 1 data: #{day_data_keys}")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 1 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # 1. Проверяем, что пользователь действительно в дне 1
            if @user.self_help_state&.include?("day_1")
              # 2. Восстанавливаем сессию через сервис
              day_service.resume_session
              answer_callback_query("Продолжаем День 1!")
            else
              # 3. Если не в дне 1, начинаем заново
              log_warn("User not in day 1 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 1 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day1Service
            # (выбор техники дыхания, таймер, рефлексия и т.д.)
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day1Handler] #{message}"
          end
          
          def log_error(message, error)
            Rails.logger.error "[Day1Handler] #{message}"
            Rails.logger.error "Error: #{error.message}" if error
            Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}" if error&.backtrace
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day1Handler] #{message} - #{data}"
          end
        end
      end
    end
  end
end