module Telegram
  module Handlers
    module SelfHelpHandlers
      module DayHandlers
        class Day13Handler < BaseHandler
          # Паттерн для всех callback'ов дня 13
        CALLBACK_PATTERN = /^(start_day_13_|continue_day_13_|day_13_|procrastination_exercise_completed|view_my_procrastination_tasks|mark_task_completed|procrastination_first_step_done)/          
          def process
            log_info("Processing Day 13 callback: #{@callback_data}")
            
            # Создаем сервис Дня 13
            day_service = SelfHelp::Days::Day13Service.new(@bot_service, @user, @chat_id)
            
            # Определяем тип действия
            case @callback_data
            when 'start_day_13_from_proposal'
              # Это начало дня из предложения (из программы)
              handle_day_start(day_service)
            when 'start_procrastination_exercise'
              # Это кнопка "Начать упражнение" на экране интро
              handle_intro_continue(day_service)
            when 'continue_day_13_content'
              handle_day_continue(day_service)
            when 'view_my_procrastination_tasks'
              # Обработчик для просмотра задач
              handle_view_tasks(day_service)
            when 'mark_task_completed'
              # Обработчик для отметки задачи как выполненной
              handle_mark_task_completed(day_service)
            when 'procrastination_first_step_done'
              # Обработчик для завершения первого шага
              handle_first_step_completed(day_service)
            when 'procrastination_exercise_completed'
              # Завершение упражнения
              handle_exercise_completion(day_service)
            when 'day_13_start_new_practice'
              # Начало новой практики
              handle_new_practice_start(day_service)
            else
              # Все специфичные кнопки дня 13 делегируем сервису
              handle_day_specific_button(day_service)
            end
            
          rescue => e
            log_error("Error in Day13Handler", e)
            answer_callback_query("Произошла ошибка. Попробуйте еще раз.")
          end
          
          private

          def handle_new_practice_start(day_service)
            log_info("Starting new procrastination practice for user #{@user.telegram_id}")
            
            # Очищаем данные предыдущей практики
            clear_day_13_data
            
            # Устанавливаем состояние для начала новой практики
            @user.set_self_help_step("day_13_exercise_in_progress")
            
            # Начинаем новую практику
            day_service.deliver_exercise
            
            answer_callback_query("🚀 Начинаем новую практику преодоления прокрастинации!")
          end

          def handle_view_tasks(day_service)
            log_info("Showing procrastination tasks for user #{@user.telegram_id}")
            
            # Используем метод из Day13Service для показа задач
            day_service.show_tasks
            
            # Отвечаем на callback
            answer_callback_query("📋 Показываю ваши задачи по прокрастинации")
          end
          
          def handle_mark_task_completed(day_service)
            log_info("Marking task as completed for user #{@user.telegram_id}")
            
            # Используем метод из Day13Service для отметки задачи
            day_service.mark_task_completed
            
            # Отвечаем на callback
            answer_callback_query("✅ Задача отмечена как выполненная!")
          end
          
          def handle_first_step_completed(day_service)
            log_info("Processing first step completion for user #{@user.telegram_id}")
            
            # Пользователь сделал первый шаг
            send_message(
              text: "🚀 **Отлично! Первый шаг сделан!**\n\nВы преодолели самое сложное — начали.\n\nКак вы себя чувствуете после этого маленького действия?",
              parse_mode: 'Markdown'
            )
            
            # Устанавливаем состояние для описания ощущений
            day_service.store_day_data('current_step', 'feelings')
            
            answer_callback_query("🎯 Первый шаг сделан!")
          end

          def handle_exercise_completion(day_service)
            log_info("Completing Day 13 exercise for user #{@user.telegram_id}")
            
            # Проверяем, что пользователь в процессе дня 13
            if @user.self_help_state&.include?("day_13")
              # Вызываем завершение упражнения через сервис
              day_service.complete_exercise
              answer_callback_query("✅ Упражнение дня 13 завершено!")
            else
              log_warn("User not in day 13 exercise state", state: @user.self_help_state)
              answer_callback_query("Сначала начните День 13")
            end
          end
          
          def handle_day_start(day_service)
            Rails.logger.debug "[DEBUG] Day13Handler.handle_day_start called for start_day_13_from_proposal"
            Rails.logger.debug "[DEBUG] User #{@user.id} state before checks: completed_days=#{@user.completed_days.inspect}, current_day_started_at=#{@user.current_day_started_at}"
            
            log_info("Starting Day 13 from proposal for user #{@user.telegram_id}")
            
            # 1. Проверяем, завершен ли день 12
            unless @user.completed_days&.include?(12)
              Rails.logger.debug "[DEBUG] Day 12 not completed, denying access"
              answer_callback_query("❌ Сначала завершите День 12")
              return
            end
            
            # 2. Проверяем ограничения времени - ИСПРАВЛЕННЫЙ МЕТОД
            Rails.logger.debug "[DEBUG] Calling @user.can_start_day?(13) for start_day_13_from_proposal..."
            
            # Пробуем использовать can_start_day_program? если он есть
            if @user.respond_to?(:can_start_day_program?)
              can_start_result = @user.can_start_day_program?(13)
            else
              can_start_result = @user.can_start_day?(13)
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(13) returned: #{can_start_result.inspect}"
            
            if can_start_result != true
              error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
              Rails.logger.debug "[DEBUG] can_start_day?(13) failed: #{error_message}"
              log_warn("User cannot start day 13 from proposal", reason: error_message)
              answer_callback_query(error_message)
              return
            end
            
            Rails.logger.debug "[DEBUG] can_start_day?(13) passed, proceeding..."
            
            # 3. Очищаем данные дня 13
            clear_day_13_data
            
            # 4. Начинаем день в системе отслеживания
            Rails.logger.debug "[DEBUG] Setting current_day_started_at to now (day 13)"
            @user.start_day_program(13)
            
            # 5. Устанавливаем начальное состояние
            @user.set_self_help_step("day_13_intro")
            
            # 6. Запускаем упражнение через сервис
            day_service.deliver_intro
            
            # 7. Отвечаем на callback - ИСПРАВЛЕНО
            answer_callback_query("🚀 Начинаем День 13: Преодоление прокрастинации!")
            Rails.logger.debug "[DEBUG] Day 13 started successfully from proposal"
          end
          
          def handle_intro_continue(day_service)
  Rails.logger.debug "[DEBUG] Day13Handler.handle_intro_continue called for start_procrastination_exercise"
  Rails.logger.debug "[DEBUG] User #{@user.id} current state: #{@user.self_help_state}"
  
  log_info("Continuing Day 13 from intro for user #{@user.telegram_id}")
  
  # Проверяем, что пользователь уже в состоянии day_13_intro
  if @user.self_help_state == "day_13_intro"
    Rails.logger.debug "[DEBUG] User in day_13_intro state, proceeding to exercise"
    
    # 1. Обновляем состояние
    @user.set_self_help_step("day_13_exercise_in_progress")
    
    # 2. Запускаем упражнение через сервис
    day_service.deliver_exercise
    
    # 3. Отвечаем на callback
    answer_callback_query("Продолжаем работу с прокрастинацией!")
  else
    # ВАЖНОЕ ИСПРАВЛЕНИЕ: 
    # Если пользователь нажал "Начать борьбу с прокрастинацией" из меню,
    # он хочет начать НОВУЮ практику, а не продолжить старую!
    
    # Сначала проверяем, не хочет ли пользователь начать новую практику
    # Если пользователь уже завершил рефлексию (day_13_reflection_done),
    # спросим, что он хочет
    
    if @user.self_help_state == "day_13_reflection_done"
      Rails.logger.debug "[DEBUG] User completed reflection, asking for new practice or completion"
      
      # Показываем меню выбора
      send_message(
        text: "🎯 Вы уже освоили практику преодоления прокрастинации.\n\nЧто вы хотите сделать?",
        reply_markup: {
          inline_keyboard: [
            [
              { text: "🚀 Начать новую практику", callback_data: 'day_13_start_new_practice' },
              { text: "✅ Завершить день 13", callback_data: 'day_13_complete_exercise' }
            ],
            [
              { text: "📋 Посмотреть мои задачи", callback_data: 'view_my_procrastination_tasks' }
            ]
          ]
        }
      )
      
      answer_callback_query("Что вы хотите сделать?")
    elsif @user.self_help_state&.include?("day_13")
      Rails.logger.debug "[DEBUG] User already in day 13 state (#{@user.self_help_state}), resuming session"
      
      # Пользователь в процессе дня 13 - продолжаем
      day_service.resume_session
      answer_callback_query("🔄 Возвращаемся к практике дня 13!")
    else
      # Если пользователь не в состоянии day_13_intro, проверяем можно ли начать день
      Rails.logger.warn("[DEBUG] User not in day_13_intro state, checking if can start day")
      log_warn("User not in intro state, checking if can start day", state: @user.self_help_state)
      
      # Если день еще не начат, начинаем его
      handle_day_start(day_service)
    end
  end
end
          
          def clear_day_13_data
            # Очищаем данные дня 13 из self_help_program_data
            log_info("Clearing Day 13 data for user #{@user.telegram_id}")
            
            if @user.respond_to?(:clear_day_data)
              # Используем метод модели, если есть
              cleared = @user.clear_day_data(13)
              log_info("Cleared via model: #{cleared.inspect}")
            else
              # Ручная очистка
              day_data_keys = @user.self_help_program_data.keys.select { |k| k.start_with?('day_13_') }
              
              if day_data_keys.any?
                day_data_keys.each do |key|
                  @user.self_help_program_data.delete(key)
                end
                @user.save
                log_info("Manually cleared keys: #{day_data_keys}")
              else
                log_info("No Day 13 data to clear")
              end
            end
          end
          
          def handle_day_continue(day_service)
  log_info("Continuing Day 13 for user #{@user.telegram_id}, state: #{@user.self_help_state}")
  
  # Проверяем, что пользователь действительно в дне 13
  if @user.self_help_state&.include?("day_13")
    # Если пользователь только на intro-экране, переходим к упражнению
    if @user.self_help_state == "day_13_intro"
      day_service.deliver_exercise
    else
      # Для других состояний восстанавливаем сессию
      day_service.resume_session
    end
    answer_callback_query("🔄 Продолжаем День 13!")
  else
    # Если не в дне 13, начинаем заново
    log_warn("User not in day 13 state, starting fresh", state: @user.self_help_state)
    handle_day_start(day_service)
  end
end
          
          def handle_day_specific_button(day_service)
            log_info("Handling Day 13 specific button: #{@callback_data}")
            
            # Все специфичные кнопки делегируем Day13Service
            day_service.handle_button(@callback_data)
          end
          
          def log_info(message)
            Rails.logger.info "[Day13Handler] #{message} - User: #{@user.telegram_id}"
          end
          
          def log_error(message, error = nil)
            Rails.logger.error "[Day13Handler] #{message} - User: #{@user.telegram_id}"
            if error
              Rails.logger.error "Error: #{error.message}"
              Rails.logger.error "Backtrace: #{error.backtrace.first(5).join(', ')}"
            end
          end
          
          def log_warn(message, data = {})
            Rails.logger.warn "[Day13Handler] #{message} - User: #{@user.telegram_id}"
            Rails.logger.warn "Data: #{data}" if data.any?
          end
        end
      end
    end
  end
end