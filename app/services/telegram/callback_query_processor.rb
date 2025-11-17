# app/services/telegram/callback_query_processor.rb
module Telegram
  class CallbackQueryProcessor
    include TelegramMarkupHelper # Для генерации клавиатур

    def initialize(bot, user, callback_query_data)
      @bot = bot
      @user = user
      @callback_query_data = callback_query_data
      @chat_id = callback_query_data[:message][:chat][:id]
      @message_id = callback_query_data[:message][:message_id]
      @callback_data = callback_query_data[:data]
    end

    def process
      case @callback_data
      when 'tests'
        # Это, кажется, устаревшая кнопка, но оставим для примера
        tests = Test.all.pluck(:name)
        test_list = tests.map.with_index { |test, index| "#{index + 1}. #{test}" }.join("\n")
        @bot.send_message(chat_id: @chat_id, text: "Вот список тестов:\n#{test_list}")

      when 'help'
        @bot.send_message(chat_id: @chat_id, text: "Я умею показывать список тестов и начинать их. Ждите новых функций!")

      when 'show_test_categories'
            TestManager.new(@bot, @user, @chat_id).show_categories(@message_id)

          when /^prepare_(anxiety|depression|eq|luscher)_test$/
            test_type = $1
            TestManager.new(@bot, @user, @chat_id).prepare_test(test_type)

          when /^start_(anxiety|depression|eq)_test$/
            test_type = $1
            # Здесь нам нужно будет отследить завершение теста.
            # Для этого, QuizRunner должен отправлять callback_query после завершения.
            # Предположим, что он отправляет callback_query вида: 'test_completed_<test_type>'
            QuizRunner.new(@bot, @user, @chat_id).start_quiz(test_type)

          when 'start_luscher_test'
            LuscherTestService.new(@bot, @user, @chat_id).start_test

          when 'show_luscher_interpretation'
            LuscherTestService.new(@bot, @user, @chat_id).show_interpretation

          when 'start_emotion_diary'
            EmotionDiaryService.new(@bot, @user, @chat_id).start_diary_menu

          when 'new_emotion_diary_entry'
            EmotionDiaryService.new(@bot, @user, @chat_id).start_new_entry

          when 'show_emotion_diary_entries'
            EmotionDiaryService.new(@bot, @user, @chat_id).show_entries

          when 'back_to_main_menu'
            send_main_menu("Выберите действие:")

          when /^answer_(\d+)_(\d+)_(\d+)$/
            question_id = $1.to_i
            answer_option_id = $2.to_i
            test_result_id = $3.to_i
            QuizRunner.new(@bot, @user, @chat_id).process_answer(question_id, answer_option_id, test_result_id, @message_id)

          when /^luscher_choose_(.+)$/
            color_code = $1
            LuscherTestService.new(@bot, @user, @chat_id).process_choice(color_code, @message_id)

          # Новые обработчики для программы самопомощи
          when 'start_self_help_program' # Запуск вводного сообщения
            # Это обрабатывается в TelegramWebhooksController, но если нужно, можно и здесь
            @bot.send_message(chat_id: @chat_id, text: "Привет! Начнем наше путешествие к улучшению самочувствия. Сегодня предлагаю пройти короткий тест на депрессию и тревожность. Это поможет нам лучше понять твое состояние. Ты готов?", reply_markup: TelegramMarkupHelper.self_help_intro_markup)

          when 'start_self_help_program_tests' # Нажатие "Начать программу"
            SelfHelpService.new(@bot, @user, @chat_id).start_tests_sequence

          when 'yes' # Ответ "Да"
            handle_yes_response

          when 'no' # Ответ "Нет"
            handle_no_response

          # Обработчики завершения тестов (предполагается, что QuizRunner их отправляет)
          when 'test_completed_depression'
            handle_test_completed_depression
          when 'start_anxiety_test_from_sequence' # callback_data, которое будет приходить после согласия на тест тревожности
            handle_start_anxiety_test_from_sequence
          when 'test_completed_anxiety'
            handle_test_completed_anxiety
          when 'no_anxiety_test_sequence' # Пользователь отказался от теста на тревожность
            handle_no_anxiety_test_sequence

          when 'start_day_1_content' # <--- ЭТОТ ОБРАБОТЧИК УЖЕ ДОЛЖЕН БЫТЬ
            handle_start_day_1_content

          when 'continue_day_1_content' # <--- ДОБАВЛЯЕМ ЭТОТ НОВЫЙ БЛОК
              handle_continue_day_1_content

          when 'complete_day_1' # <--- И ЭТОТ БЛОК ДЛЯ КНОПКИ "Завершить День 1"
            handle_complete_day_1

          when 'day_1_exercise_completed' # <--- ДОБАВЛЯЕМ ЭТОТ НОВЫЙ БЛОК
            handle_day_1_exercise_completed
          
          when 'start_day_2_content'
              handle_start_day_2_content # Этот метод уже вызывает deliver_day_2_content

            when 'start_day_2_exercise_audio' # <--- НОВЫЙ ОБРАБОТЧИК
              handle_start_day_2_exercise_audio

            when 'day_2_exercise_completed' # <--- НОВЫЙ ОБРАБОТЧИК
              handle_day_2_exercise_completion

            when 'start_day_3_content' # <--- НОВЫЙ ОБРАБОТЧИК
              handle_start_day_3_content

            when 'day_3_enter_gratitude' # <--- НОВЫЙ ОБРАБОТЧИК
              SelfHelpService.new(@bot, @user, @chat_id).start_gratitude_entry

            when 'show_gratitude_entries' # <--- НОВЫЙ ОБРАБОТЧИК
              SelfHelpService.new(@bot, @user, @chat_id).show_gratitude_entries

            when 'complete_day_3' # <--- НОВЫЙ ОБРАБОТЧИК
              SelfHelpService.new(@bot, @user, @chat_id).complete_day_3
            when 'start_day_4_content'
              handle_start_day_4_content
            when 'start_day_4_exercise'
              SelfHelpService.new(@bot, @user, @chat_id).start_day_4_exercise
            when 'day_4_exercise_completed'
              handle_day_4_exercise_completed

            when 'start_day_5_content'
              handle_start_day_5_content
            when 'day_5_exercise_completed'
              handle_day_5_exercise_completed

            when 'start_day_6_content'
              handle_start_day_6_content
            when 'day_6_exercise_completed'
              handle_day_6_exercise_completed

            when 'start_day_7_content'
              handle_start_day_7_content
            when 'complete_day_7' # <--- ЭТОТ ОБРАБОТЧИК ДОЛЖЕН БЫТЬ
        handle_complete_day_7 # Перенаправляем на новый хэндлер

      when 'start_day_8_content' # <--- НОВЫЙ ОБРАБОТЧИК
        handle_start_day_8_content

      when 'day_8_confirm_exercise' # <--- НОВЫЙ ОБРАБОТЧИК (ответ "Да" на готовность)
        handle_day_8_confirm_exercise

      when 'day_8_decline_exercise' # <--- НОВЫЙ ОБРАБОТЧИК (ответ "Нет" на готовность)
        handle_day_8_decline_exercise

      when 'day_8_stopped_thought_first_try' # <--- НОВЫЙ ОБРАБОТЧИК (после первого "СТОП!")
        handle_day_8_stopped_thought_first_try

      when 'day_8_ready_for_distraction' # <--- НОВЫЙ ОБРАБОТЧИК (после второго "СТОП!")
        handle_day_8_ready_for_distraction

      when /^day_8_distraction_(music|video|friend|exercise|book)$/ # <--- НОВЫЕ ОБРАБОТЧИКИ для выбора отвлечения
        distraction_type = $1
        handle_day_8_distraction_choice(distraction_type)

      when 'day_8_exercise_completed' # <--- НОВЫЙ ОБРАБОТЧИК (после завершения упражнения)
        handle_day_8_exercise_completion

     when 'complete_program_final' # Если у вас есть это, то, возможно, это финальное завершение
        # Здесь может быть логика для завершения всей программы,
        # например, отправка финального сообщения и возврат в главное меню
        @bot.send_message(chat_id: @chat_id, text: "Программа полностью завершена! Возвращайтесь в любое время.", reply_markup: main_menu_markup)
        @user.clear_self_help_program # Здесь можно сбросить, так как это финал.

      else
        Rails.logger.warn "Неизвестный callback_data: #{@callback_data}" # Исправлено на @callback_data
        @bot.send_message(chat_id: @chat_id, text: "Извините, я не понял эту команду.")
      end
    end

    private


    def handle_start_day_4_content
      if @user.get_self_help_step == 'day_3_completed'
        SelfHelpService.new(@bot, @user, @chat_id).deliver_day_4_content
      else
        @bot.send_message(chat_id: @chat_id, text: "Вы еще не завершили предыдущий день.")
      end
    end

    def handle_day_4_exercise_completed
      if @user.get_self_help_step == 'day_4_exercise_in_progress'
        SelfHelpService.new(@bot, @user, @chat_id).handle_day_4_exercise_completion
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_start_day_5_content
      if @user.get_self_help_step == 'day_4_completed'
        SelfHelpService.new(@bot, @user, @chat_id).deliver_day_5_content
      else
        @bot.send_message(chat_id: @chat_id, text: "Вы еще не завершили предыдущий день.")
      end
    end

    def handle_day_5_exercise_completed
      if @user.get_self_help_step == 'day_5_intro' # Шаг 'day_5_intro' установлен в deliver_day_5_content
        SelfHelpService.new(@bot, @user, @chat_id).handle_day_5_exercise_completion
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_start_day_6_content
      if @user.get_self_help_step == 'day_5_completed'
        SelfHelpService.new(@bot, @user, @chat_id).deliver_day_6_content
      else
        @bot.send_message(chat_id: @chat_id, text: "Вы еще не завершили предыдущий день.")
      end
    end

    def handle_day_6_exercise_completed
      if @user.get_self_help_step == 'day_6_intro'
        SelfHelpService.new(@bot, @user, @chat_id).handle_day_6_exercise_completion
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_start_day_7_content
      if @user.get_self_help_step == 'day_6_completed'
        SelfHelpService.new(@bot, @user, @chat_id).deliver_day_7_content
      else
        @bot.send_message(chat_id: @chat_id, text: "Вы еще не завершили предыдущий день.")
      end
    end

    # Модифицируем этот метод для перехода к Дню 8
    def handle_complete_day_7
      if @user.get_self_help_step == 'day_7_completed'
        SelfHelpService.new(@bot, @user, @chat_id).propose_day_8
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния для завершения Дня 7. Начните /start.")
        # @user.clear_self_help_program # <-- УБРАТЬ ОТСЮДА
      end
    end

    def handle_start_day_8_content
      # Здесь мы ожидаем, что пользовательский шаг УЖЕ 'day_8_intro',
      # так как этот callback_data отправляется методом propose_day_8,
      # который его и устанавливает.
      if @user.get_self_help_step == 'day_8_intro'
        SelfHelpService.new(@bot, @user, @chat_id).deliver_day_8_intro # Этот метод установит next_step 'day_8_waiting_for_consent'
      else
        @bot.send_message(chat_id: @chat_id, text: "Вы пытаетесь начать День 8 из неправильного состояния. Напишите /start, чтобы вернуться в главное меню и начать заново.")
        # @user.clear_self_help_program # <-- УБРАТЬ ОТСЮДА
      end
    end

    def handle_day_8_confirm_exercise
      if @user.get_self_help_step == 'day_8_waiting_for_consent'
        SelfHelpService.new(@bot, @user, @chat_id).start_day_8_exercise_instructions
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_day_8_decline_exercise
      if @user.get_self_help_step == 'day_8_waiting_for_consent'
        @bot.send_message(chat_id: @chat_id, text: "Хорошо, мы можем попробовать эту технику позже. Возвращайтесь в главное меню.", reply_markup: main_menu_markup)
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_day_8_stopped_thought_first_try
      if @user.get_self_help_step == 'day_8_first_try'
        SelfHelpService.new(@bot, @user, @chat_id).continue_day_8_second_try
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_day_8_ready_for_distraction
      if @user.get_self_help_step == 'day_8_second_try'
        SelfHelpService.new(@bot, @user, @chat_id).ask_for_distraction_choice
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_day_8_distraction_choice(distraction_type)
      if @user.get_self_help_step == 'day_8_choosing_distraction'
        SelfHelpService.new(@bot, @user, @chat_id).guide_distraction(distraction_type)
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_day_8_exercise_completion
      if @user.get_self_help_step == 'day_8_distraction_in_progress'
        SelfHelpService.new(@bot, @user, @chat_id).handle_day_8_exercise_completion
      else
        @bot.send_message(chat_id: @chat_id, text: "Ошибка состояния. Начните /start.")
      end
    end

    def handle_start_day_1_content
            if @user.get_self_help_step == 'day_1_content_intro'
              @user.set_self_help_step('day_1_content_delivered') # Это действие перемещаем сюда
              SelfHelpService.new(@bot, @user, @chat_id).deliver_day_1_content # <--- Вызываем метод из SelfHelpService
            else
              @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так при попытке начать день 1. Напишите /start для начала заново.")
            end
          end

          # --- НОВЫЙ ПРИВАТНЫЙ МЕТОД handle_continue_day_1_content ---
          def handle_continue_day_1_content
            if @user.get_self_help_step == 'day_1_content_delivered' # Проверяем, что пользователь на правильном шаге
              SelfHelpService.new(@bot, @user, @chat_id).send_day_1_exercise # <--- Запускаем упражнение или следующую часть контента
            else
              @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так при продолжении дня 1. Напишите /start для начала заново.")
            end
          end

          # --- НОВЫЙ ПРИВАТНЫЙ МЕТОД handle_complete_day_1 ---
          def handle_complete_day_1
            if @user.get_self_help_step == 'day_1_content_delivered'
              @user.set_self_help_step('day_1_completed') # Отмечаем день 1 как завершенный
              @bot.send_message(chat_id: @chat_id, text: "Поздравляю с завершением первого дня! Отдохните и приходите завтра за новым контентом.", reply_markup: main_menu_markup)
            else
              @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так при завершении дня 1. Напишите /start для начала заново.")
            end
          end

          def handle_day_1_exercise_completed
        if @user.get_self_help_step == 'day_1_exercise_in_progress'
          SelfHelpService.new(@bot, @user, @chat_id).handle_day_1_exercise_completion
        else
          @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так при завершении упражнения дня 1. Напишите /start для начала заново.")
        end
      end

    def handle_start_day_2_content
        # Проверяем, что пользователь закончил предыдущий день
        if @user.get_self_help_step == 'day_1_completed'
          @user.set_self_help_step('day_2_content_intro') # Устанавливаем шаг для начала дня 2
          SelfHelpService.new(@bot, @user, @chat_id).deliver_day_2_content # <--- Запускаем доставку контента для Дня 2
        else
          @bot.send_message(chat_id: @chat_id, text: "Вы еще не завершили предыдущий день или что-то пошло не так. Напишите /start для начала заново.")
        end
      end

    def handle_start_day_2_exercise_audio
            if @user.get_self_help_step == 'day_2_intro_delivered'
              SelfHelpService.new(@bot, @user, @chat_id).send_day_2_exercise_audio
            else
              @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так при запуске упражнения дня 2. Напишите /start для начала заново.")
            end
          end

          def handle_day_2_exercise_completion
            if @user.get_self_help_step == 'day_2_exercise_in_progress'
              SelfHelpService.new(@bot, @user, @chat_id).handle_day_2_exercise_completion
            else
              @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так при завершении упражнения дня 2. Напишите /start для начала заново.")
            end
          end

          def handle_start_day_3_content
      if @user.get_self_help_step == 'day_2_completed'
        # Шаг устанавливается в SelfHelpService#deliver_day_3_content
        SelfHelpService.new(@bot, @user, @chat_id).deliver_day_3_content
      else
        @bot.send_message(chat_id: @chat_id, text: "Вы еще не завершили предыдущий день или что-то пошло не так. Напишите /start для начала заново.")
      end
    end

    def handle_test_completed_depression
      # Проверяем, что пользователь находится в состоянии прохождения тестов
      # Предполагаем, что `SelfHelpService` установил `taking_depression_test`
      if @user.get_self_help_step == 'taking_depression_test' || @user.get_self_help_step == 'taking_tests'
        @user.set_self_help_step('day_1_anxiety_intro') # Переводим пользователя к введению в тест на тревожность
        @bot.send_message(
          chat_id: @chat_id,
          text: "Отлично, тест на депрессию завершен! Теперь перейдем к тесту на тревожность. Вы готовы?",
          reply_markup: yes_no_markup(callback_data_yes: 'start_anxiety_test_from_sequence', callback_data_no: 'no_anxiety_test_sequence')
        )
      else
        @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так в последовательности тестов. Напишите /start.")
      end
    end

    def handle_start_anxiety_test_from_sequence
      if @user.get_self_help_step == 'day_1_anxiety_intro'
        @user.set_self_help_step('taking_anxiety_test') # Обновляем шаг пользователя
        @bot.send_message(chat_id: @chat_id, text: "Запускаю тест на тревожность...")
        QuizRunner.new(@bot, @user, @chat_id).start_quiz('anxiety') # Запускаем тест на тревожность
      else
        @bot.send_message(chat_id: @chat_id, text: "Что-то пошло не так. Напишите /start для начала заново.")
      end
    end

    def handle_no_anxiety_test_sequence
      if @user.get_self_help_step == 'day_1_anxiety_intro'
        @bot.send_message(chat_id: @chat_id, text: "Хорошо, мы можем пройти тест позже. Возвращаемся в главное меню.", reply_markup: main_menu_markup)
      else
        @bot.send_message(chat_id: @chat_id, text: "Пожалуйста, вернитесь в главное меню, нажав /start.")
      end
    end

    def handle_test_completed_anxiety
      # После завершения теста на тревожность (GAD-7)
      # User уже должен быть на шаге 'taking_anxiety_test' или 'tests_completed'
      # Мы должны перейти к введению Дня 1.
      @user.set_self_help_step('day_1_content_intro')
      SelfHelpService.new(@bot, @user, @chat_id).deliver_day_1_intro_message # <-- Новый метод
    end

    def send_main_menu(text)
          @bot.send_message(chat_id: @chat_id, text: text, reply_markup: main_menu_markup)
        end

        # Обработка ответа "Да"
        def handle_yes_response
          current_step = @user.get_self_help_step
          if current_step == 'day_1_intro'
            # Здесь запускаем цепочку тестов через SelfHelpService
            SelfHelpService.new(@bot, @user, @chat_id).start_tests_sequence
          elsif current_step == 'day_2_intro'
            # Пользователь готов начать упражнение на 2 день
            SelfHelpService.new(@bot, @user, @chat_id).send_body_scan_audio
          else
            @bot.send_message(chat_id: @chat_id, text: "Похоже, вы уже начали программу. Нажмите /start, чтобы вернуться в главное меню.")
          end
        end

        # Обработка ответа "Нет"
        def handle_no_response
          if @user.get_self_help_step == 'day_1_intro'
            @bot.send_message(chat_id: @chat_id, text: "Хорошо, мы можем начать в любой другой момент. Просто нажмите кнопку '⭐ Программа самопомощи ⭐' в главном меню.", reply_markup: TelegramMarkupHelper.main_menu_markup)
          elsif @user.get_self_help_step == 'day_2_intro'
            @bot.send_message(chat_id: @chat_id, text: "Хорошо, мы можем вернуться к упражнению позже. Нажмите /start, чтобы вернуться в главное меню.")
            @user.set_self_help_step('day_2_completed') # Отмечаем, что день 2 пройден, чтобы перейти к дню 3
            # Переходим к дню 3
            prepare_day_3
          else
            @bot.send_message(chat_id: @chat_id, text: "Похоже, вы уже начали программу. Нажмите /start, чтобы вернуться в главное меню.")
          end
        end

        def prepare_day_3
          SelfHelpService.new(@bot, @user, @chat_id).prepare_day_3
        end
      end
end
