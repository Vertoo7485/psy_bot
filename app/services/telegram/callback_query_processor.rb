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

      else
        @bot.send_message(chat_id: @chat_id, text: "Неизвестная команда callback_data: #{@callback_data}")
      end
    end

    private

    def send_main_menu(text)
      @bot.send_message(chat_id: @chat_id, text: text, reply_markup: main_menu_markup)
    end
  end
end
