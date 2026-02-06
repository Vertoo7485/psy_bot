# app/services/telegram/handlers/self_help_handlers/day_handlers/day_17_handler.rb
module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day17Handler < BaseHandler
          # Паттерн для всех callback'ов дня 17
          CALLBACK_PATTERN = /^(start_day_17_|continue_day_17_|day_17_)/
          
          def process
            log_info("Processing Day 17 callback: #{@callback_data}")
            
            # Создаем сервис Дня 17
            day_service = SelfHelp::Days::Day17Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_17_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_day_17_content'
              # Это кнопка "Начать практику" на экране интро
              handle_intro_continue(day_service)
            when 'continue_day_17_content'
              handle_day_continue(day_service)
            when 'day_17_exercise_completed', 'day_17_complete_exercise'
              handle_exercise_completion(day_service)
            when 'day_17_show_letters', 'view_compassion_letters'
              handle_show_letters(day_service)
            when 'day_17_new_letter', 'start_day_17_exercise'
              handle_new_letter(day_service)
            else
              # Все специфичные кнопки дня 17 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day17Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day17Handler.handle_day_start called for start_day_17_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 17 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 16
            unless @user.completed_days&.include?(16)
              Rails.logger.debug "[DEBUG] Day 16 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 16")
              return
            end
            
            # 2. Проверяем ограничения времени
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(17) for start_day_17_from_proposal..."
            can_start_result = @user.can_start_day?(17)
            Rails.logger.debug "[DEBUG] can_start_day?(17) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(17) failed: #{error_message}"
              log_warn("User cannot start day 17 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(17) passed, proceeding..."
            
            # 3. Очищаем данные дня 17
            clear_day_17_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 17)"
            @user.start_day_program(17)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_17_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback
            answer_callback_query("💝 Начинаем День 17: Искусство самосострадания!")
            Rails.logger.debug "[DEBUG] Day 17 started successfully from proposal"
          end
          
          def handle_intro_continue(day_service)
            Rails.logger.debug "[DEBUG] Day17Handler.handle_intro_continue called for start_day_17_content"
            Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
            
            log_info("Continuing Day 17 from intro for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь уже в состоянии day_17_intro
            if @user.self_help_state == "day_17_intro"
              Rails.logger.debug "[DEBUG] User in day_17_intro state, proceeding to exercise"
              
              # 1. Обновляем состояние
              @user.set_self_help_step("day_17_exercise_in_progress")
              
              # 2. Запускаем упражнение через сервис
              day_service.deliver_exercise
              
              # 3. Отвечаем на callback
              answer_callback_query("Продолжаем практику самосострадания!")
            else
              # Если пользователь не в состоянии day_17_intro, проверяем можно ли начать день
              Rails.logger.warn("[DEBUG] User not in day_17_intro state, checking if can start day")
              log_warn("User not in intro state, checking if can start day", state: @user.self_help_state)
              
              # Если день еще не начат, начинаем его
              handle_day_start(day_service)
            end
          end
          
          def clear_day_17_data
            # Очищаем данные дня 17 из self_help_program_data
            log_info("Clearing Day 17 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(17)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_17_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 17 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
            log_info("Continuing Day 17 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
            
            # Проверяем, что пользователь действительно в дне 17
            if @user.self_help_state&.include?("day_17")
              # Если пользователь только на intro-экране, переходим к упражнению
              if @user.self_help_state == "day_17_intro"
                day_service.deliver_exercise
              else
                # Для других состояний восстанавливаем сессию
                day_service.resume_session
              end
              answer_callback_query("🔄 Продолжаем День 17!")
            else
              # Если не в дне 17, начинаем заново
              log_warn("User not in day 17 state, starting fresh", state: @user.self_help_state)
              handle_day_start(day_service)
            end
          end
          
          def handle_exercise_completion(day_service)
            log_info("Completing Day 17 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь в процессе дня 17
            if @user.self_help_state&.include?("day_17")
              day_service.complete_exercise
              answer_callback_query("✅ Письмо самосострадания завершено!")
            else
              log_warn("User not in day 17 exercise state", state: @user.self_help_state)
              answer_callback_query("Сначала начните День 17")
            end
          end
          
          def handle_show_letters(day_service)
            log_info("Showing compassion letters for user #{@user.telegram_id}")
            
            if day_service.respond_to?(:show_previous_letters)
              day_service.show_previous_letters
              answer_callback_query("📚 Показываю ваши письма")
            else
              # Альтернативный способ показа писем
              show_compassion_letters_simple
            end
          end
          
          def handle_new_letter(day_service)
            log_info("Starting new compassion letter for user #{@user.telegram_id}")
            
            # Если пользователь уже в дне 17, продолжаем
            if @user.self_help_state&.include?("day_17")
              day_service.deliver_exercise
            else
              # Если не в дне 17, но хочет написать новое письмо
              # Это новая практика вне программы
              day_service.start_new_practice
            end
            answer_callback_query("✍️ Начинаем новое письмо!")
          end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 17 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day17Service
            if day_service.respond_to?(:handle_button)
              day_service.handle_button(@callback_data)
            else
              log_warn("Day17Service doesn't have handle_button method")
              send_message(text: "Эта функция пока недоступна.")
            end
          end
          
          def show_compassion_letters_simple
            letters = CompassionLetter.where(user_id: @user.id).order(created_at: :desc).limit(5)
            
            if letters.empty?
              send_message(
                text: "📭 У вас пока нет сохраненных писем самосострадания.\n\nНапишите первое письмо в упражнении дня 17!",
                reply_markup: TelegramMarkupHelper.day_17_start_exercise_markup
              )
              return
            end
            
            message = "📚 Ваши письма самосострадания:\n\n"
            
            letters.each_with_index do |letter, index|
              date = letter.entry_date.strftime('%d.%m.%Y')
              preview = letter.situation_text.to_s.truncate(50)
              
              message += "#{index + 1}. 📅 #{date}\n"
              message += "   💭 #{preview}\n\n"
            end
            
            send_message(
              text: message,
              parse_mode: 'Markdown',
              reply_markup: TelegramMarkupHelper.compassion_letters_markup
            )
          end
          
          def log_info(message)
            Rails.logger.info "[Day17Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day17Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day17Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end