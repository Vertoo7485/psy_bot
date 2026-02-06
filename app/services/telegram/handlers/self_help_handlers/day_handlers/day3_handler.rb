# app/services/telegram/handlers/self_help_handlers/day_handlers/day3_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day3Handler < BaseHandler
          # Паттерн для всех callback'ов дня 3
          CALLBACK_PATTERN = /^(start_day_3_|continue_day_3_|day_3_)/
          
          def process
            log_info("Processing Day 3 callback: #{@callback_data}")
            
            # Создаем сервис Дня 3
            day_service = SelfHelp::Days::Day3Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_3_from_proposal', 'start_day_3_content'
              handle_day_start(day_service)
            when 'continue_day_3_content'
              handle_day_continue(day_service)
            else
              # Все специфичные кнопки дня 3 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day3Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_start(day_service)
            log_info("Starting Day 3 from scratch for user #{@user.telegram_id}")
            
            # Проверяем, завершен ли день 2
            unless @user.completed_days&.include?(2)
              answer_callback_query("❌ Сначала завершите День 2")
              return
            end
            
            # Проверяем ограничения времени
            can_start_result = @user.can_start_day?(3)
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              log_warn("User cannot start day 3", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            # 1. Очищаем данные дня 3
            clear_day_3_data
            
            # 2. Начинаем день в системе отслеживания
            @user.start_day_program(3)
            
            # 3. Устанавливаем начальное состояние
            @user.set_self_help_step("day_3_intro")
            
            # 4. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 5. Отвечаем на callback
            answer_callback_query("🙏 Начинаем День 3: Практика благодарности!")
          end
          
          def clear_day_3_data
            # Очищаем данные дня 3 из self_help_program_data
            log_info("Clearing Day 3 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(3)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_3_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 3 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 3 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 3
            if @user.self_help_state&.include?("day_3")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_3_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 3!")
            else
              # Если не в дне 3, начинаем заново
              log_warn("User not in day 3 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 3 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day3Service
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day3Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day3Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day3Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end