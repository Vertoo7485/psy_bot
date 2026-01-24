# app/services/telegram/handlers/self_help_handlers/day23_handler.rb

module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day23Handler < BaseHandler
          # Паттерн для всех callback'ов дня 23
          CALLBACK_PATTERN = /^(start_day_23_|continue_day_23_|day_23_|complete_day_23|view_analysis_|back_to_day_23_menu|retry_day_23_)/
          
          def process
            log_info("Processing Day 23 callback: #{@callback_data}")
            
            # Создаем сервис Дня 23
            day_service = SelfHelp::Days::Day23Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_23_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_23_exercise'
              # Это кнопка "Начать анализ" на экране интро
              handle_intro_continue(day_service)
            when 'start_day_23_content'
              # Это кнопка "Начать День 23" из меню
              handle_intro_continue(day_service)
            when 'continue_day_23_content'
              handle_day_continue(day_service)
            when 'retry_day_23_exercise'
              # Это повторное прохождение дня - БЕЗ ПРОВЕРОК
              handle_day_retry(day_service)
            when 'day_23_add_diary_entry', 'day_23_use_existing', 'day_23_show_diary_stats',
                 'day_23_show_entries', 'day_23_show_thoughts', 'day_23_show_emotions',
                 'day_23_finish_categories', 'day_23_finish_thoughts', 'day_23_complete_exercise',
                 'day_23_previous_step', 'day_23_restart_analysis',
                 /^day_23_period_/, /^day_23_situation_/, /^day_23_thought_/,
                 'day_23_custom_categories', 'day_23_custom_thoughts'
              # Эти действия делегируем сервису
              handle_day_specific_button(day_service)
            else
              # Все специфичные кнопки дня 23 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day23Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_retry(day_service)
            log_info("Retrying Day 23 exercise for user #{@user.telegram_id}")
            
            # 1. Очищаем данные дня 23
            clear_day_23_data
            
            # 2. Устанавливаем состояние интро (без проверок времени и завершения)
            @user.set_self_help_step("day_23_intro")
            
            # 3. Очищаем данные self_help_program_data для дня 23
            clear_self_help_day_data
            
            # 4. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 5. Отвечаем на callback
            answer_callback_query("🔄 Начинаем День 23 заново!")
          end
          
          def clear_self_help_day_data
            # Очищаем только данные дня 23 в self_help_program_data
            data = @user.read_attribute(:self_help_program_data) || {}
            
            if data.is_a?(Hash)
              keys_to_delete = data.keys.select do |key|
                key.to_s.start_with?('day_23_')
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
            log_info("Starting Day 23 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 22
            unless @user.completed_days&.include?(22)
              answer_callback_query("❌ Сначала завершите День 22")
              return
            end
            
            # 2. Проверяем ограничения времени
            can_start_result = @user.can_start_day?(23)
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              log_warn("User cannot start day 23 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            # 3. Очищаем данные дня 23
            clear_day_23_data
            
            # 4. Начинаем день в системе отслеживания
            @user.start_day_program(23)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_23_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("📊 Начинаем День 23: Анализ дневника!")
          end
          
          def handle_intro_continue(day_service)
            log_info("Continuing Day 23 from intro for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь уже в состоянии day_23_intro
            if @user.self_help_state == "day_23_intro"
              # 1. Обновляем состояние
              @user.set_self_help_step("day_23_exercise_in_progress")
              
              # 2. Запускаем упражнение через сервис
              day_service.deliver_exercise
              
              # 3. Отвечаем на callback
              answer_callback_query("Продолжаем анализ дневника!")
            else
              # Если пользователь не в состоянии day_23_intro, проверяем можно ли начать день
              log_warn("User not in intro state, checking if can start day", state: @user.self_help_state)
              
              # Если день еще не начат, начинаем его
              handle_day_start(day_service)
            end
          end
          
          def clear_day_23_data
            # Очищаем данные дня 23 из self_help_program_data
            log_info("Clearing Day 23 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(23)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              data = @user.read_attribute(:self_help_program_data) || {}
              day_data_keys = data.keys.select { |k| k.to_s.start_with?('day_23_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  data.delete(key)
                end
                @user.update(self_help_program_data: data)
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 23 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 23 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 23
            if @user.self_help_state&.include?("day_23")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_23_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 23!")
            else
              # Если не в дне 23, начинаем заново
              log_warn("User not in day 23 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 23 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day23Service
            if day_service.respond_to?(:handle_button)
              day_service.handle_button(@callback_data)
            else
              log_error("Day23Service doesn't have handle_button method")
              answer_callback_query("Ошибка обработки кнопки")
            end
          end
          
          def log_info(message)
            Rails.logger.info "[Day23Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day23Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day23Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end