require 'telegram/bot'
require 'json'

class TelegramWebhooksController < ApplicationController
  def message
    bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])

    # Проверяем, что это обычное сообщение, а не callback_query
    if params[:message]
      message = params[:message]
      text = message[:text].to_s.strip

      user = User.find_or_create_by(telegram_id: message[:from][:id]) do |u|
        u.first_name = message[:from][:first_name]
        u.last_name = message[:from][:last_name]
        u.username = message[:from][:username]
      end

      case text
      when '/start'
        # Создаем клавиатуру в виде Hash
        kb = {
          inline_keyboard: [
            [{ text: 'Список тестов', callback_data: 'tests' }],
            [{ text: 'Помощь', callback_data: 'help' }]
          ]
        }

        # Конвертируем Hash в JSON string
        markup = kb.to_json

        bot.send_message(chat_id: message[:chat][:id], text: "Привет! Выберите действие:", reply_markup: markup)
      when '/help'
        bot.send_message(chat_id: message[:chat][:id], text: "Я пока умею показывать список тестов и начинать их. Используйте кнопки.")
      when /^\/test_(\d+)$/ # Регулярное выражение для команды /test_<id>
        test_id = $1 # Извлекаем ID теста из регулярного выражения
        start_test(bot, message[:chat][:id], test_id) # Вызываем метод для запуска теста
      when /^тест (\d+)$/i  # Альтернативный вариант: "тест <id>", регистронезависимо
        test_id = $1
        start_test(bot, message[:chat][:id], test_id)
      else
        bot.send_message(chat_id: message[:chat][:id], text: "Я не понимаю эту команду. Напишите /help или используйте кнопки.")
      end

    # Обрабатываем callback_query
    elsif params[:callback_query]
      callback_query = params[:callback_query]
      callback_data = callback_query[:data]
      message = callback_query[:message] # Use callback_query[:message]

      case callback_data
      when 'tests'
        tests = ["Тест 1", "Тест 2", "Тест 3"]
        test_list = tests.map.with_index { |test, index| "#{index + 1}. #{test}" }.join("\n")
        bot.send_message(chat_id: message[:chat][:id], text: "Вот список тестов:\n#{test_list}")
      when 'help'
        bot.send_message(chat_id: message[:chat][:id], text: "Я умею показывать список тестов и начинать их. Ждите новых функций!")
      end
    end

    render plain: 'OK'
  end

  private

  def start_test(bot, chat_id, test_id)
    # Здесь нужно добавить логику для запуска теста с ID test_id
    # Например, отправить первый вопрос теста
    bot.send_message(chat_id: chat_id, text: "Начинаем тест #{test_id}...")
  end
end
