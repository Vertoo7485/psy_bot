
require 'telegram/bot'
require 'json'

class TelegramWebhooksController < ApplicationController
  before_action :set_bot

  def message
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
        kb = {
          inline_keyboard: [
            [{ text: 'Список тестов', callback_data: 'tests' }],
            [{ text: 'Пройти тест тревожности', callback_data: 'start_anxiety_test' }],
            [{ text: 'Помощь', callback_data: 'help' }]
          ]
        }
        markup = kb.to_json

        @bot.send_message(chat_id: message[:chat][:id], text: "Привет! Выберите действие:", reply_markup: markup)
      when '/help'
        @bot.send_message(chat_id: message[:chat][:id], text: "Я пока умею показывать список тестов и начинать их. Используйте кнопки.")
      when /^\/test_(\d+)$/
        test_id = $1
        start_test(@bot, message[:chat][:id], test_id)
      when /^тест (\d+)$/i
        test_id = $1
        start_test(@bot, message[:chat][:id], test_id)
      else
        @bot.send_message(chat_id: message[:chat][:id], text: "Я не понимаю эту команду. Напишите /help или используйте кнопки.")
      end

    elsif params[:callback_query]
      callback_query = params[:callback_query]
      callback_data = callback_query[:data]
      message = callback_query[:message]

      # Получаем user из callback_query
      user = User.find_by(telegram_id: callback_query[:from][:id])

      case callback_data
      when 'tests'
        tests = Test.all.pluck(:name) # Получаем имена всех тестов
        test_list = tests.map.with_index { |test, index| "#{index + 1}. #{test}" }.join("\n")
        @bot.send_message(chat_id: message[:chat][:id], text: "Вот список тестов:\n#{test_list}")

      when 'help'
        @bot.send_message(chat_id: message[:chat][:id], text: "Я умею показывать список тестов и начинать их. Ждите новых функций!")

      when 'start_anxiety_test'
        start_anxiety_test(@bot, message[:chat][:id], user)

      when /^answer_(\d+)_(\d+)_(\d+)$/  # answer_questionId_answerOptionId_testResultId
        question_id = $1.to_i
        answer_option_id = $2.to_i
        test_result_id = $3.to_i
        process_answer(@bot, message[:chat][:id], user, question_id, answer_option_id, test_result_id)

      end
    end

    render plain: 'OK'
  end

  private

  def set_bot
    @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
  end

  def start_test(bot, chat_id, test_id)
    bot.send_message(chat_id: chat_id, text: "Начинаем тест #{test_id}...")
  end

  def start_anxiety_test(bot, chat_id, user)
    test = Test.find_by(name: "Тест Тревожности")
    if test.nil?
      bot.send_message(chat_id: chat_id, text: "Тест не найден.")
      return
    end
    Rails.logger.debug "Test ID: #{test.id}"
    Rails.logger.debug "User ID: #{user.id}"
    test_result = TestResult.new(user: user, test: test) # Создаем объект TestResult
  
    if test_result.save # Пытаемся сохранить
      Rails.logger.debug "TestResult ID: #{test_result.id}"
      question = test.questions.first
      send_question(bot, chat_id, question, test_result.id)
    else
      Rails.logger.error "Ошибка при создании TestResult: #{test_result.errors.full_messages.join(', ')}" # Логируем ошибки
      bot.send_message(chat_id: chat_id, text: "Произошла ошибка при создании теста. Попробуйте позже.")
    end
  end
  


  def send_question(bot, chat_id, question, test_result_id)
    # Создаем кнопки с вариантами ответов
    inline_keyboard = question.answer_options.map do |answer_option|
      callback_data = "answer_#{question.id}_#{answer_option.id}_#{test_result_id}"
      Rails.logger.debug "Callback data for option: #{answer_option.text} - #{callback_data}"  # Добавлено логирование
      [{ text: answer_option.text, callback_data: callback_data }]
    end
    markup = { inline_keyboard: inline_keyboard }.to_json

    Rails.logger.debug "Sending question with markup: #{markup}"

    bot.send_message(chat_id: chat_id, text: question.text, reply_markup: markup)
  end
  


  def process_answer(bot, chat_id, user, question_id, answer_option_id, test_result_id)
    Rails.logger.debug "process_answer called with: chat_id=#{chat_id}, user=#{user.id}, question_id=#{question_id}, answer_option_id=#{answer_option_id}, test_result_id=#{test_result_id}"

    question = Question.find(question_id)
    answer_option = AnswerOption.find(answer_option_id)
    test_result = TestResult.find(test_result_id)
  
    Answer.create(test_result: test_result, question: question, answer_option: answer_option)
  
    test = test_result.test
    next_question = test.questions.where("id > ? AND test_id = ?", question_id, test.id).order(:id).first
  
    if next_question
      # Извлекаем message_id из callback_query
      message_id = params[:callback_query][:message][:message_id]
      edit_question(bot, chat_id, message_id, next_question, test_result_id)
    else
      Rails.logger.debug "Тест завершен, подсчитываем результаты"
      # Тест завершен, подсчитываем результаты
      calculate_and_send_results(bot, chat_id, test_result_id)
    end    
  end
  
  
  def edit_question(bot, chat_id, message_id, question, test_result_id)
    # Создаем кнопки с вариантами ответов
    inline_keyboard = question.answer_options.map do |answer_option|
      [{ text: answer_option.text, callback_data: "answer_#{question.id}_#{answer_option.id}_#{test_result_id}" }]
    end
    markup = { inline_keyboard: inline_keyboard }.to_json
  
    begin
      #bot.edit_message(chat_id: chat_id, message_id: message_id, text: question.text, reply_markup: markup)
      bot.send_message(chat_id: chat_id, text: question.text, reply_markup: markup)
    rescue StandardError => e
      puts "Ошибка при отправке сообщения: #{e.message}"
    end
  end

  def calculate_and_send_results(bot, chat_id, test_result_id)
    test_result = TestResult.find(test_result_id)
    answers = test_result.answers.includes(:question, :answer_option)
  
    part1_answers = answers.where(questions: { part: 1 })
    part2_answers = answers.where(questions: { part: 2 })
  
    Rails.logger.debug "Part 1 Answers:"
    part1_answers.each do |answer|
      Rails.logger.debug "  Question: #{answer.question.text}, Answer: #{answer.answer_option.text}, Value: #{answer.answer_option.value}"
    end
  
    Rails.logger.debug "Part 2 Answers:"
    part2_answers.each do |answer|
      Rails.logger.debug "  Question: #{answer.question.text}, Answer: #{answer.answer_option.text}, Value: #{answer.answer_option.value}"
    end
  
    #  Изменяем логику подсчета баллов:
    part1_score = part1_answers.sum { |answer| answer.answer_option.value }
    part2_score = part2_answers.sum { |answer| answer.answer_option.value }
  
    Rails.logger.debug "Part 1 Score: #{part1_score}"
    Rails.logger.debug "Part 2 Score: #{part2_score}"
  
    total_score = part1_score + part2_score
  
    interpretation = case total_score
                     when 0..30
                       "Низкий уровень тревожности."
                     when 31..50
                       "Умеренный уровень тревожности."
                     else
                       "Высокий уровень тревожности."
                     end
  
    message = "Результаты теста:\n"
    message += "Часть 1 (Текущее состояние): #{part1_score}\n"
    message += "Часть 2 (Обычное состояние): #{part2_score}\n"
    message += "Общий балл: #{total_score}\n"
    message += "Интерпретация: #{interpretation}"
  
    test_result.update(score: total_score, completed_at: Time.now)
  
    bot.send_message(chat_id: chat_id, text: message)
  end
  
end