# app/services/telegram/handlers/self_help_handlers/day_handlers/day22_handler.rb

module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day22Handler < BaseHandler
          # Паттерн для всех callback'ов дня 22
          CALLBACK_PATTERN = /^(start_day_22_|continue_day_22_|day_22_|complete_day_22|view_smart_|back_to_day_22_menu|retry_day_22_)/
          
          def process
            log_info("Processing Day 22 callback: #{@callback_data}")
            
            # Создаем сервис Дня 22
            day_service = SelfHelp::Days::Day22Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_22_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_22_exercise'
              # Это кнопка "Начать создание целей" на экране интро
              handle_intro_continue(day_service)
            when 'start_day_22_content'
              # Это кнопка "Начать День 22" из меню
              handle_intro_continue(day_service)
            when 'continue_day_22_content'
              handle_day_continue(day_service)
            when 'retry_day_22_exercise'
              # Это повторное прохождение дня - БЕЗ ПРОВЕРОК
              handle_day_retry(day_service)
            when 'day_22_show_examples', 'day_22_show_goals', 'day_22_add_goal', 'day_22_complete_exercise',
                 'day_22_skip_step', 'day_22_restart_goal', 'day_22_previous_step', /^day_22_domain_/
              # Эти действия делегируем сервису
              handle_day_specific_button(day_service)
            else
              # Все специфичные кнопки дня 22 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day22Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_retry(day_service)
            log_info("Retrying Day 22 exercise for user #{@user.telegram_id}")
            
            # 1. Очищаем данные дня 22
            clear_day_22_data
            
            # 2. Устанавливаем состояние интро (без проверок времени и завершения)
            @user.set_self_help_step("day_22_intro")
            
            # 3. Очищаем данные self_help_program_data для дня 22
            clear_self_help_day_data
            
            # 4. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 5. Отвечаем на callback
            answer_callback_query("🔄 Начинаем День 22 заново!")
          end
          
          def clear_self_help_day_data
            # Очищаем только данные дня 22 в self_help_program_data
            if @user.self_help_program_data.is_a?(Hash)
              keys_to_delete = @user.self_help_program_data.keys.select do |key|
                key.to_s.start_with?('day_22_')
              end
              
              keys_to_delete.each do |key|
                @user.self_help_program_data.delete(key)
              end
              
              if @user.self_help_program_data_changed?
                @user.save
                log_info("Cleared self_help_program_data keys: #{keys_to_delete}")
              end
            end
          end
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day22Handler.handle_day_start called for start_day_22_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 22 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 21
            unless @user.completed_days&.include?(21)
              Rails.logger.debug "[DEBUG] Day 21 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 21")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(22) for start_day_22_from_proposal..."
            can_start_result = @user.can_start_day?(22)
            Rails.logger.debug "[DEBUG] can_start_day?(22) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(22) failed: #{error_message}"
              log_warn("User cannot start day 22 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(22) passed, proceeding..."
            
            # 3. Очищаем данные дня 22
            clear_day_22_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 22)"
            
            @user.start_day_program(22)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_22_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("🎯 Начинаем День 22: SMART-цели!")
            Rails.logger.debug "[DEBUG] Day 22 started successfully from proposal"
          end
          
          def handle_intro_continue(day_service)
            Rails.logger.debug "[DEBUG] Day22Handler.handle_intro_continue called for start_day_22_exercise"
            Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
            
            log_info("Continuing Day 22 from intro for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь уже в состоянии day_22_intro
            if @user.self_help_state == "day_22_intro"
              Rails.logger.debug "[DEBUG] User in day_22_intro state, proceeding to exercise"
              
              # 1. Обновляем состояние
              @user.set_self_help_step("day_22_exercise_in_progress")
              
              # 2. Запускаем упражнение через сервис
              day_service.deliver_exercise
              
              # 3. Отвечаем на callback
              answer_callback_query("Продолжаем создание целей!")
            else
              # Если пользователь не в состоянии day_22_intro, проверяем можно ли начать день
              Rails.logger.warn("[DEBUG] User not in day_22_intro state, checking if can start day")
              log_warn("User not in intro state, checking if can start day", state: @user.self_help_state)
              
              # Если день еще не начат, начинаем его
              handle_day_start(day_service)
            end
          end
          
          def clear_day_22_data
            # Очищаем данные дня 22 из self_help_program_data
            log_info("Clearing Day 22 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(22)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_22_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 22 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 22 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 22
            if @user.self_help_state&.include?("day_22")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_22_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 22!")
            else
              # Если не в дне 22, начинаем заново
              log_warn("User not in day 22 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 22 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day22Service
            if day_service.respond_to?(:handle_button)
              day_service.handle_button(@callback_data)
            else
              log_error("Day22Service doesn't have handle_button method")
              answer_callback_query("Ошибка обработки кнопки")
            end
          end
          
          def log_info(message)
            Rails.logger.info "[Day22Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day22Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day22Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end