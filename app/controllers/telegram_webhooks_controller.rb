require 'telegram/bot'
require 'json'

class TelegramWebhooksController < ApplicationController

  include ActionView::Helpers::AssetUrlHelper # <<< ДОБАВЬТЕ ЭТУ СТРОКУ
  include Rails.application.routes.url_helpers # Может понадобиться для asset_path в некоторых случаях

  before_action :set_bot

  COLOURS = [
    {name: 'Темно-синий', value: 1, code: 'dark_blue'},
    {name: 'Сине-зеленый', value: 2, code: 'blue_green'},
    {name: 'Зеленый', value: 3, code: 'green'},
    {name: 'Красно-желтый', value: 4, code: 'red_yellow'},
    {name: 'Желтый', value: 5, code: 'yellow'},
    {name: 'Красный', value: 6, code: 'red'},
    {name: 'Фиолетовый', value: 7, code: 'purple'},
    {name: 'Коричневый', value: 8, code: 'brown'}
  ].freeze

  def message
    if params[:message]
      message = params[:message]
      text = message[:text].to_s.strip

      user = User.find_or_create_by(telegram_id: message[:from][:id]) do |u|
        u.first_name = message[:from][:first_name]
        u.last_name = message[:from][:last_name]
        u.username = message[:from][:username]
      end

      if user.current_diary_step.present? # Проверяем, находится ли пользователь в процессе заполнения дневника
            handle_diary_answer(@bot, message[:chat][:id], user, text)
      else

      case text
      when '/start'
            kb = {
              inline_keyboard: [
                [{ text: 'Список тестов', callback_data: 'show_test_categories' }],
                [{ text: 'Дневник эмоций', callback_data: 'start_emotion_diary' }], #  Новая кнопка
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

      when 'show_test_categories'
        show_test_categories(@bot, message[:chat][:id], message[:message_id], user)
      when 'prepare_anxiety_test'
        prepare_anxiety_test(@bot, message[:chat][:id], user)

      when 'prepare_depression_test'
        prepare_depression_test(@bot, message[:chat][:id], user)

      when 'prepare_eq_test'
        prepare_eq_test(@bot, message[:chat][:id], user)

      when 'prepare_luscher_test'
        prepare_luscher_test(@bot, message[:chat][:id], user)

      when 'start_anxiety_test'
        start_anxiety_test(@bot, message[:chat][:id], user)

      when 'start_depression_test'
        start_depression_test(@bot, message[:chat][:id], user)

      when 'start_eq_test'
        start_eq_test(@bot, message[:chat][:id], user) # <--- Добавляем обработчик

      when 'start_luscher_test'
        start_luscher_test(@bot, message[:chat][:id], user)

      when 'start_luscher_stage_two'
        start_luscher_stage_two(@bot, message[:chat][:id], user)

      when 'show_luscher_interpretation'
        show_luscher_interpretation(@bot, message[:chat][:id], user)

      when 'start_emotion_diary'
        start_emotion_diary(@bot, message[:chat][:id], user)

      when 'new_emotion_diary_entry'
        start_new_emotion_diary_entry(@bot, message[:chat][:id], user)

      when 'show_emotion_diary_entries'
        show_emotion_diary_entries(@bot, message[:chat][:id], user)

      when 'back_to_main_menu'
        kb = {
          inline_keyboard: [
            [{ text: 'Список тестов', callback_data: 'show_test_categories' }],
            [{ text: 'Дневник эмоций', callback_data: 'start_emotion_diary' }],
            [{ text: 'Помощь', callback_data: 'help' }]
          ]
        }
        markup = kb.to_json

        @bot.send_message(chat_id: message[:chat][:id], text: "Привет! Выберите действие:", reply_markup: markup)

      when /^answer_(\d+)_(\d+)_(\d+)$/
        question_id = $1.to_i
        answer_option_id = $2.to_i
        test_result_id = $3.to_i
        process_answer(@bot, message[:chat][:id], user, question_id, answer_option_id, test_result_id)

      when /^luscher_choose_(.+)$/
        color_code = $1
        process_luscher_choice(@bot, message[:chat][:id], user, color_code, message[:message_id])

      end
    end

    render plain: 'OK'
  end

  private

  def set_bot
    @bot = Telegram::Bot::Client.new(ENV['TELEGRAM_BOT_TOKEN'])
  end

  def luscher_colors_keyboard(available_colors)
    buttons = available_colors.map do |color|
      # InlineKeyboardButton принимает только текст и callback_data
      [{ text: color[:name], callback_data: "luscher_choose_#{color[:code]}" }]
    end
    { inline_keyboard: buttons }.to_json
  end

  def send_color_image_with_name(bot, chat_id, color)
      # Создаем маску для поиска файла в public/assets
      # Ищем файл с именем color[:code], любым хэшем и расширением .jpeg
      file_mask = Rails.root.join('public', 'assets', "#{color[:code]}-*.jpeg")

      # Используем Dir.glob для поиска файлов, соответствующих маске
      image_files = Dir.glob(file_mask)

      if image_files.any?
        # Если найдено несколько файлов, берем первый
        image_path = image_files.first

        Rails.logger.info "Найден файл изображения: #{image_path}"

        # Открываем файл и отправляем его
        File.open(image_path, 'r') do |file|
          bot.send_photo(chat_id: chat_id, photo: file, caption: color[:name])
        end
      else
        Rails.logger.error "Файл изображения не найден для цвета: #{color[:name]}"
        bot.send_message(chat_id: chat_id, text: "Изображение для цвета '#{color[:name]}' не найдено.")
      end
    rescue => e
      Rails.logger.error "Ошибка при отправке изображения: #{e.message}"
      bot.send_message(chat_id: chat_id, text: "Произошла ошибка при отправке изображения для цвета '#{color[:name]}'.")
    end

  def show_luscher_results(first_stage, second_stage)
      first_stage_names = first_stage.map { |color_code| COLOURS.find { |c| c[:code] == color_code }[:name] }
      second_stage_names = second_stage.map { |color_code| COLOURS.find { |c| c[:code] == color_code }[:name] }

      message = "Первый выбор:\n"
      first_stage_names.each_with_index { |name, index| message += "#{index + 1}. #{name}\n" }
      message += "\nВторой выбор:\n"
      second_stage_names.each_with_index { |name, index| message += "#{index + 1}. #{name}\n" }

      message
  end

  def start_test(bot, chat_id, test_id)
    bot.send_message(chat_id: chat_id, text: "Начинаем тест #{test_id}...")
  end

  def show_test_categories(bot, chat_id, message_id, user)
    # Создаем кнопки для каждого теста
    test_buttons = []
    Test.all.each do |test|
      case test.name
      when "Тест Тревожности"
        test_buttons << [{ text: test.name, callback_data: 'prepare_anxiety_test' }]
      when "Тест Депрессии (PHQ-9)"
        test_buttons << [{ text: test.name, callback_data: 'prepare_depression_test' }]
      when "Тест EQ (Эмоциональный Интеллект)"
        test_buttons << [{ text: test.name, callback_data: 'prepare_eq_test' }]
      when "8-ми цветовой тест Люшера"
        test_buttons << [{ text: test.name, callback_data: 'prepare_luscher_test' }] #  Добавили Люшера
      else
        next
      end
    end

    # Добавляем кнопку "Назад"
    test_buttons << [{ text: 'Назад', callback_data: 'back_to_main_menu' }] # Кнопка "Назад"

    markup = { inline_keyboard: test_buttons }.to_json

    # Отправляем сообщение с кнопками тестов
    bot.send_message(chat_id: chat_id, text: "Выберите тест:", reply_markup: markup)
  end

  def prepare_anxiety_test(bot, chat_id, user)
    Rails.logger.debug "prepare_anxiety_test called (chat_id: #{chat_id}, user_id: #{user&.id})" # Добавили user&.id для избежания ошибки, если user == nil
    message = "Тест Тревожности поможет вам оценить уровень тревожности. Ответьте на вопросы, чтобы получить результат. Примерное время прохождения: 5-10 минут."
    kb = { inline_keyboard: [[{ text: 'Начать тест', callback_data: 'start_anxiety_test' }]] }.to_json
    bot.send_message(chat_id: chat_id, text: message, reply_markup: kb)
    Rails.logger.debug "prepare_anxiety_test finished (chat_id: #{chat_id}, user_id: #{user&.id})"
  end

  def prepare_depression_test(bot, chat_id, user)
    message = "Тест Депрессии (PHQ-9) - это короткий опросник, который поможет оценить ваше состояние и выявить возможные признаки депрессии.  Примерное время прохождения: 3-5 минут."
    kb = { inline_keyboard: [[{ text: 'Начать тест', callback_data: 'start_depression_test' }]] }.to_json
    bot.send_message(chat_id: chat_id, text: message, reply_markup: kb)
  end

  def prepare_eq_test(bot, chat_id, user)
    message = "Тест EQ (Эмоциональный Интеллект) поможет вам оценить вашу способность понимать и управлять своими эмоциями, а также понимать эмоции других людей. Примерное время прохождения: 7-12 минут."
    kb = { inline_keyboard: [[{ text: 'Начать тест', callback_data: 'start_eq_test' }]] }.to_json
    bot.send_message(chat_id: chat_id, text: message, reply_markup: kb)
  end

  def prepare_luscher_test(bot, chat_id, user)
    message = "8-ми цветовой тест Люшера поможет вам оценить ваше психоэмоциональное состояние. Тест состоит из двух этапов. Между этапами необходимо сделать небольшой перерыв. Готовы начать?"
    kb = { inline_keyboard: [[{ text: 'Начать тест', callback_data: 'start_luscher_test' }]] }.to_json
    bot.send_message(chat_id: chat_id, text: message, reply_markup: kb)
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

  def start_depression_test(bot, chat_id, user)
    test = Test.find_by(name: "Тест Депрессии (PHQ-9)")
    if test.nil?
      bot.send_message(chat_id: chat_id, text: "Тест не найден.")
      return
    end

    test_result = TestResult.new(user: user, test: test)

    if test_result.save
      question = test.questions.first
      send_question(bot, chat_id, question, test_result.id)
    else
      Rails.logger.error "Ошибка при создании TestResult: #{test_result.errors.full_messages.join(', ')}"
      bot.send_message(chat_id: chat_id, text: "Произошла ошибка при создании теста. Попробуйте позже.")
    end
  end

  def start_eq_test(bot, chat_id, user)
    test = Test.find_by(name: "Тест EQ (Эмоциональный Интеллект)")
    if test.nil?
      bot.send_message(chat_id: chat_id, text: "Тест не найден.")
      return
    end

    test_result = TestResult.new(user: user, test: test)

    if test_result.save
      question = test.questions.first
      send_question(bot, chat_id, question, test_result.id)
    else
      Rails.logger.error "Ошибка при создании TestResult: #{test_result.errors.full_messages.join(', ')}"
      bot.send_message(chat_id: chat_id, text: "Произошла ошибка при создании теста. Попробуйте позже.")
    end
  end

  def start_luscher_test(bot, chat_id, user)
  test = Test.find_by(name: "8-ми цветовой тест Люшера")
  if test.nil?
    bot.send_message(chat_id: chat_id, text: "Тест не найден.")
    return
  end

  TestResult.where(user: user, test: test, completed_at: nil).update_all(completed_at: Time.now, luscher_stage: :completed)

  test_result = TestResult.create(user: user, test: test, luscher_stage: :stage_one, luscher_choices: [])
  available_colors = COLOURS.shuffle
  Rails.logger.info "Начинаем отправку изображений..."

  # Отправляем сообщение с просьбой выбрать цвет
  bot.send_message(chat_id: chat_id, text: "Этап 1: Выберите цвет, который вам сейчас больше всего нравится:")
  
  # Отправляем изображения с названиями цветов по одному
  available_colors.each do |color|
    send_color_image_with_name(bot, chat_id, color)
  end

  # Создаем и отправляем клавиатуру после отправки всех изображений
  markup = luscher_colors_keyboard(available_colors)
  bot.send_message(chat_id: chat_id, text: "Выберите наиболее приятный для вам цвет, нажав на кнопку ниже:", reply_markup: markup)
end

  def start_luscher_stage_two(bot, chat_id, user)
    test = Test.find_by(name: "8-ми цветовой тест Люшера")
    test_result = TestResult.find_by(user: user, test: test, completed_at: nil)

    # Очищаем luscher_choices для второго этапа
    test_result.update(luscher_choices: [])

    available_colors = COLOURS.shuffle # Перемешиваем цвета для второго выбора
    markup = luscher_colors_keyboard(available_colors)

    bot.send_message(chat_id: chat_id, text: "Этап 2: Выберите цвет, который вам сейчас больше всего нравится:", reply_markup: markup)
  end

  def process_luscher_choice(bot, chat_id, user, color_code, message_id)
  test = Test.find_by(name: "8-ми цветовой тест Люшера")
  test_result = TestResult.find_by(user: user, test: test, completed_at: nil)

  current_choices = test_result.luscher_choices || []
  current_choices << color_code
  test_result.update(luscher_choices: current_choices)

  test_result.reload

  available_colors = COLOURS.reject { |c| current_choices.include?(c[:code]) }

  Rails.logger.debug "Текущие выборы: #{current_choices.inspect}"
  Rails.logger.debug "Доступные цвета: #{available_colors.count}"
  Rails.logger.debug "luscher_stage (после перезагрузки): #{test_result.luscher_stage.inspect}"

  if available_colors.empty?
    Rails.logger.debug "Этап закончен"
    if test_result.luscher_stage == "stage_one" # ИЗМЕНЕНО: Сравнение со строкой
      Rails.logger.debug "Переход к этапу 2"
      test_result.update(luscher_stage: :stage_two)
      bot.send_message(
  chat_id: chat_id,
  text: "Ты выбрал все 8 цветов!\nТеперь сделай небольшой перерыв (5-10 минут). Когда будешь готов, нажми кнопку \"Начать второй этап\".",
  reply_markup: { inline_keyboard: [[{ text: 'Начать второй этап', callback_data: 'start_luscher_stage_two' }]] }.to_json
)
    elsif test_result.luscher_stage == "stage_two" # ИЗМЕНЕНО: Сравнение со строкой
      Rails.logger.debug "Тест завершен"
      test_result.update(luscher_stage: :completed, completed_at: Time.now)
      bot.send_message(
  chat_id: chat_id,
  text: "Отлично! Ты завершил тест! Теперь я попробую дать тебе небольшую интерпретацию твоих результатов.",
  reply_markup: { inline_keyboard: [[{ text: 'Показать интерпретацию', callback_data: 'show_luscher_interpretation' }]] }.to_json
)
    else
      Rails.logger.debug "Неизвестный luscher_stage (ошибка логики): #{test_result.luscher_stage.inspect}"
      bot.send_message(chat_id: chat_id, text: "Произошла внутренняя ошибка теста. Пожалуйста, попробуйте начать тест заново.")
    end
  else
    # Отправляем сообщение с просьбой выбрать следующий цвет
    bot.send_message(chat_id: chat_id, text: "Выбери следующий цвет:")

    # Отправляем изображения с названиями цветов по одному
    available_colors.each do |color|
      send_color_image_with_name(bot, chat_id, color)
    end

    # Создаем и отправляем клавиатуру после отправки всех изображений
    markup = luscher_colors_keyboard(available_colors.shuffle)
    bot.send_message(chat_id: chat_id, text: "Выберите цвет, нажав на кнопку ниже:", reply_markup: markup)
  end
end

  def show_luscher_interpretation(bot, chat_id, user)
    test = Test.find_by(name: "8-ми цветовой тест Люшера")
    test_result = TestResult.find_by(user: user, test: test, completed_at: nil) || TestResult.find_by(user: user, test: test)
    first_stage = test_result.luscher_choices.first(8)
    second_stage = test_result.luscher_choices.last(8)

    results_message = show_luscher_results(first_stage, second_stage)

    # === Интерпретация на основе первого выбора (Этап 1) ===
    first_color_code = first_stage.first
    first_color = COLOURS.find { |c| c[:code] == first_color_code }
    interpretation_first = case first_color[:code]
                     when 'dark_blue'
                       "Сейчас для вас главное – спокойствие, гармония и удовлетворение. Вы стремитесь к глубоким эмоциональным связям и стабильности в отношениях. Возможно, ищете утешение и расслабление."
                     when 'blue_green'
                       "Вы нуждаетесь в признании, уверенности и самооценке. Важно чувствовать себя значимым и компетентным. Стремитесь к контролю и обладанию."
                     when 'green'
                       "Вам важна безопасность, защита и уверенность в будущем. Вы цените стабильность и постоянство, стремитесь к гармонии с собой и окружающим миром."
                     when 'red_yellow'
                       "Вы полны энергии и оптимизма, стремитесь к новым впечатлениям и активной деятельности. Важно чувствовать себя свободным и независимым."
                     when 'yellow'
                       "Вы ищете радость, легкость и свободу от ограничений. Важно чувствовать себя открытым для новых возможностей и перемен."
                     when 'red'
                       "Вы стремитесь к интенсивным переживаниям, активности и успеху. Важно чувствовать себя сильным и влиятельным, достигать поставленных целей."
                     when 'purple'
                       "Вы нуждаетесь в признании своей уникальности и индивидуальности. Важно чувствовать себя особенным и неповторимым, выражать свою креативность и интуицию."
                     when 'brown'
                       "Вы ищете комфорт, безопасность и стабильность в материальном плане. Важно чувствовать себя защищенным от жизненных невзгод."
                     else
                       "Не удалось определить интерпретацию для первого выбора."
                     end

    # === Интерпретация на основе последнего выбора (отвергаемый цвет) (Этап 1) ===
    last_color_code = first_stage.last
    last_color = COLOURS.find { |c| c[:code] == last_color_code }
    interpretation_last = case last_color[:code]
                      when 'dark_blue'
                        "Вы избегаете ситуаций, требующих эмоциональной вовлеченности и глубоких переживаний. Возможно, чувствуете усталость от рутины и ищете способы разнообразить свою жизнь."
                      when 'blue_green'
                        "Вы избегаете ситуаций, где необходимо проявлять настойчивость и бороться за свои интересы. Возможно, чувствуете неуверенность в своих силах и нуждаетесь в поддержке."
                      when 'green'
                        "Вы избегаете ситуаций, требующих ответственности и принятия решений. Возможно, чувствуете себя перегруженным обязательствами и ищете способы облегчить свою жизнь."
                      when 'red_yellow'
                        "Вы избегаете ситуаций, связанных с риском и неопределенностью. Возможно, чувствуете потребность в стабильности и безопасности."
                      when 'yellow'
                        "Вы избегаете ситуаций, требующих концентрации и внимания к деталям. Возможно, чувствуете потребность в отдыхе и расслаблении."
                      when 'red'
                        "Вы избегаете ситуаций, связанных с конфликтами и борьбой. Возможно, чувствуете потребность в гармонии и мире."
                      when 'purple'
                        "Вы избегаете ситуаций, требующих подчинения и компромиссов. Возможно, чувствуете потребность в самовыражении и независимости."
                      when 'brown'
                        "Вы избегаете ситуаций, связанных с финансовой нестабильностью и материальными трудностями. Возможно, чувствуете потребность в уверенности в завтрашнем дне."
                      else
                        "Не удалось определить интерпретацию для последнего выбора."
                      end

      # === Сравнение первого выбора между этапами ===

    message = "Важно: Помните, что это только общая информация, и она не может заменить профессиональный анализ.\nИнтерпретация на основе первого выбора:\n#{interpretation_first}\nИнтерпретация на основе второго выбора:\n#{interpretation_last}\n"
    bot.send_message(chat_id: chat_id, text: message)
  end

  def start_emotion_diary(bot, chat_id, user)
        kb = {
          inline_keyboard: [
            [{ text: 'Новая запись', callback_data: 'new_emotion_diary_entry' }],
            [{ text: 'Мои записи', callback_data: 'show_emotion_diary_entries' }], # Новая кнопка
            [{ text: 'Назад', callback_data: 'back_to_main_menu' }]
          ]
        }
        markup = kb.to_json
        bot.send_message(chat_id: chat_id, text: "Выберите действие:", reply_markup: markup)
  end

  def start_new_emotion_diary_entry(bot, chat_id, user)
        # Начинаем процесс заполнения дневника
        user.update(current_diary_step: 'situation', diary_data: {})
        bot.send_message(chat_id: chat_id, text: "Запись в дневник. Шаг 1: Опишите конкретную ситуацию, которая вызвала у вас негативные чувства. \nЭто может быть что-то, что произошло на работе, в личной жизни, или даже просто мысль, которая пришла в голову. \nБудьте максимально конкретны: кто, что, где, когда.\nПример: Я получил(а) отказ на собеседовании.")
  end

  def show_emotion_diary_entries(bot, chat_id, user)
        entries = user.emotion_diary_entries.order(date: :desc) # Получаем записи пользователя, отсортированные по дате

        if entries.empty?
          bot.send_message(chat_id: chat_id, text: "У вас пока нет записей в дневнике.")
          return
        end

        # Формируем сообщение со списком записей
        message = "Ваши записи в дневнике:\n\n"
        entries.each_with_index do |entry, index|
          message += "#{index + 1}. *#{entry.date.strftime('%d.%m.%Y')}*\n"  # Добавляем дату записи
          message += "  - Ситуация: #{entry.situation.truncate(50)}\n" #Сокращаем текст записи
          message += "  - Мысли: #{entry.thoughts.truncate(50)}\n" #Сокращаем текст записи
          message += "  - Эмоции: #{entry.emotions.truncate(50)}\n" #Сокращаем текст записи
          message += "  - Поведение: #{entry.behavior.truncate(50)}\n" #Сокращаем текст записи
          message += "  - Доказательства против: #{entry.evidence_against.truncate(50)}\n" #Сокращаем текст записи
          message += "  - Новые мысли: #{entry.new_thoughts.truncate(50)}\n" #Сокращаем текст записи
          message += "\n"
        end

        bot.send_message(chat_id: chat_id, text: message, parse_mode: 'Markdown')
  end

  def handle_diary_answer(bot, chat_id, user, text)
        case user.current_diary_step
        when 'situation'
          user.diary_data['situation'] = text
          user.update(current_diary_step: 'thoughts', diary_data: user.diary_data)
          bot.send_message(chat_id: chat_id, text: "Шаг 2: Запишите мысли, которые возникли у вас в этой ситуации.\nЧто вы думали о себе, о других, о ситуации в целом?\nЭти мысли могут быть автоматическими, быстрыми и не всегда осознанными. Постарайтесь их выявить.\nПример: Я ни на что не гожусь. Я никогда не найду работу.")
        when 'thoughts'
          user.diary_data['thoughts'] = text
          user.update(current_diary_step: 'emotions', diary_data: user.diary_data)
          bot.send_message(chat_id: chat_id, text: "Шаг 3: Опишите ваши чувства, которые были результатом этих мыслей.\nЧто вы чувствовали (например, тревогу, грусть, гнев)?")
        when 'emotions'
          user.diary_data['emotions'] = text
          user.update(current_diary_step: 'behavior', diary_data: user.diary_data)
          bot.send_message(chat_id: chat_id, text: "Шаг 4: Опишите ваши поведение.\nКак вы поступили (например, спорили, ушли в себя)?")
        when 'behavior'
          user.diary_data['behavior'] = text
          user.update(current_diary_step: 'evidence_against', diary_data: user.diary_data)
          bot.send_message(chat_id: chat_id, text: "Шаг 5: Теперь постарайтесь оспорить свои мысли из шага 2. \nЗадайте себе вопросы: Есть ли доказательства, подтверждающие эту мысль? \nЕсть ли доказательства, опровергающие ее? \nКакие есть альтернативные способы взглянуть на эту ситуацию? \nЯвляется ли эта мысль полезной для меня? Помните, что цель - не заменить негативные мысли позитивными, а сделать их более реалистичными и сбалансированными.\nПример: Доказательства, подтверждающие: Я получила отказ.\nДоказательства, опровергающие: У меня есть опыт и навыки, которые соответствуют многим другим вакансиям. Это было только одно собеседование.\nАльтернативный взгляд: Возможно, я просто не подошла для этой конкретной компании, или у них были другие кандидаты, которые лучше соответствовали их требованиям.\nПолезность мысли: Эта мысль только заставляет меня чувствовать себя хуже и мешает мне продолжать поиск работы.")
        when 'evidence_against'
          user.diary_data['evidence_against'] = text
          user.update(current_diary_step: 'new_thoughts', diary_data: user.diary_data)
          bot.send_message(chat_id: chat_id, text: "Шаг 6: Сформулируйте новую, более рациональную и полезную мысль, которая учитывает все ваши опровержения.\nЭта мысль должна быть более реалистичной и помогать вам чувствовать себя лучше и действовать более конструктивно.\nПример: Отказ на собеседовании - это неприятно, но это не значит, что я ни на что не гожусь. Я учту опыт этого собеседования и продолжу искать работу, которая мне подходит.")
        when 'new_thoughts'
      user.diary_data['new_thoughts'] = text
      # Сохраняем запись в базу данных
      EmotionDiaryEntry.create(
        user: user,
        date: Date.today, # Или запросить у пользователя
        situation: user.diary_data['situation'],
        thoughts: user.diary_data['thoughts'],
        emotions: user.diary_data['emotions'],
        behavior: user.diary_data['behavior'],
        evidence_against: user.diary_data['evidence_against'],
        new_thoughts: user.diary_data['new_thoughts']
      )
      # Очищаем состояние
      user.update(current_diary_step: nil, diary_data: {})

      # Отправляем главное меню
      kb = {
        inline_keyboard: [
          [{ text: 'Список тестов', callback_data: 'show_test_categories' }],
          [{ text: 'Дневник эмоций', callback_data: 'start_emotion_diary' }],
          [{ text: 'Помощь', callback_data: 'help' }]
        ]
      }
      markup = kb.to_json
      bot.send_message(chat_id: chat_id, text: "Дневник заполнен и сохранен! Выберите следующее действие:", reply_markup: markup) #изменено сообщение
    else
      bot.send_message(chat_id: chat_id, text: "Неизвестная команда.  Пожалуйста, начните заново с /start.")
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
    test = test_result.test

    answers = test_result.answers.includes(:question, :answer_option)

    total_score = answers.sum { |answer| answer.answer_option.value }

    # Логика интерпретации результатов для теста тревожности
    if test.name == "Тест Тревожности"
      interpretation = case total_score
                       when 20..40
                         "Низкий уровень тревожности."
                       when 41..60
                         "Умеренный уровень тревожности."
                       else
                         "Высокий уровень тревожности."
                       end
    # Логика интерпретации результатов для теста депрессии
    elsif test.name == "Тест Депрессии (PHQ-9)"
      # Скорректированные диапазоны интерпретации
      interpretation = case total_score
                       when 0..4  #  0-4 + 9
                         "Минимальная депрессия. Вам может не потребоваться лечение."
                       when 5..9 # 5-9 + 9
                         "Легкая депрессия. Может потребоваться наблюдение или легкие изменения в образе жизни."
                       when 10..14 # 10-14 + 9
                         "Умеренная депрессия. Рекомендуется обратиться к врачу для обсуждения возможных вариантов лечения, включая терапию и/или медикаменты."
                       when 15..19 # 15-19 + 9
                         "Умеренно тяжелая депрессия. Рекомендуется обратиться к врачу для обсуждения возможных вариантов лечения, включая терапию и/или медикаменты."
                       when 20..27 # 20-27 + 9
                         "Тяжелая депрессия. Необходима немедленная консультация с врачом. Важно рассмотреть терапию и/или медикаменты."
                       else
                         "Невозможно определить уровень депрессии."  # Обработка неожиданных значений
                       end
    # Логика интерпретации результатов для теста EQ
    elsif test.name == "Тест EQ (Эмоциональный Интеллект)"
      interpretation = case total_score
                       when 10..25
                         "Низкий уровень EQ. Вам может быть сложно понимать и управлять своими эмоциями, а также эмоциями других людей. Рекомендуется уделить внимание развитию эмоционального интеллекта."
                       when 26..40
                         "Средний уровень EQ. У вас есть определенные навыки в области эмоционального интеллекта, но есть области, в которых можно улучшить."
                       when 41..50
                         "Высокий уровень EQ. Вы хорошо понимаете и управляете своими эмоциями, а также эмпатичны к другим людям."
                       else
                         "Невозможно определить уровень EQ."
                       end

    else
      interpretation = "Неизвестный тест. Невозможно определить результаты."
    end

    message = "Результаты теста:\n"
    message += "Интерпретация: #{interpretation}"

    test_result.update(score: total_score, completed_at: Time.now)

    bot.send_message(chat_id: chat_id, text: message)
  end
  
  
end