# app/services/telegram/message_processor.rb
module Telegram
  class MessageProcessor
    include TelegramMarkupHelper # Для генерации клавиатур

    def initialize(bot, user, message_data)
      @bot = bot
      @user = user
      @message_data = message_data
      @chat_id = message_data[:chat][:id]
      @text = message_data[:text].to_s.strip
    end

    def process
      if @user.current_diary_step.present?
        EmotionDiaryService.new(@bot, @user, @chat_id).handle_answer(@text)
      else
        case @text
        when '/start'
          send_main_menu("Привет! Выберите действие:")
        when '/help'
          @bot.send_message(chat_id: @chat_id, text: "Я пока умею показывать список тестов и начинать их. Используйте кнопки.")
        when /^\/test_(\d+)$/, /^тест (\d+)$/i
          test_id = $1
          # Можно добавить логику для запуска теста по ID, если это необходимо
          @bot.send_message(chat_id: @chat_id, text: "Запуск теста по ID #{test_id} пока не реализован через текстовую команду. Используйте кнопки.")
        else
          @bot.send_message(chat_id: @chat_id, text: "Я не понимаю эту команду. Напишите /help или используйте кнопки.")
        end
      end
    end

    private

    def send_main_menu(text)
      @bot.send_message(chat_id: @chat_id, text: text, reply_markup: main_menu_markup)
    end
  end
end
