# app/services/luscher_test_service.rb
class LuscherTestService
  # Константы
  COLOURS = [
    { 
      code: "dark_blue", 
      name: "Темно-синий", 
      primary: true,
      first_interpretation: "Ваша потребность в покое и удовлетворенности реализована. Вы не стремитесь к изменениям и довольны существующим положением дел. Если этот цвет был выбран одним из первых, это указывает на стремление к комфорту, порядку и эмоциональной стабильности. Вы ищете гармонии и защищенности.",
      last_interpretation: "Вы испытываете нехватку спокойствия и удовлетворенности, возможно, чувствуете напряжение или неудовлетворенность существующей ситуацией. Вам может не хватать порядка и эмоциональной стабильности, вы ищете способ избежать дискомфорта."
    },
    { 
      code: "blue_green", 
      name: "Сине-зеленый", 
      primary: true,
      first_interpretation: "Вы стремитесь утвердить себя и свои принципы, чувствуете себя уверенно и можете сопротивляться внешнему давлению. Этот цвет символизирует настойчивость и стремление к самоконтролю. Если он выбран в начале, это говорит о желании утвердить свою правоту и быть признанным.",
      last_interpretation: "Вы чувствуете, что не можете утвердить себя, испытываете неуверенность или внутреннее сопротивление. Возможно, вам не хватает самоконтроля или вы ощущаете внешнее давление, с которым трудно справиться."
    },
    { 
      code: "red_yellow", 
      name: "Оранжево-красный", 
      primary: true,
      first_interpretation: "Вы испытываете эмоциональное возбуждение, жажду активности, силы и энергии. Ваша жизнеспособность высока, и вы готовы к действию. Вы стремитесь к успеху и хотите получить от жизни максимум. Этот цвет говорит о потребности в волнении, сильных переживаниях и страстности.",
      last_interpretation: "Вы испытываете упадок энергии, разочарование или подавленность. Возможно, вам не хватает жизненной силы или вы ощущаете бессилие перед лицом препятствий. Это может указывать на усталость от постоянных требований и необходимость в отдыхе."
    },
    { 
      code: "yellow", 
      name: "Желтый", 
      primary: true,
      first_interpretation: "Вы ищете освобождения от трудностей и препятствий, стремитесь к счастью, свободе и новых возможностях. Вы открыты для приключений и перемен. Этот цвет означает оптимизм, надежду и потребность в личностном росте и развитии. Вы готовы к новым начинаниям.",
      last_interpretation: "Вы ощущаете тревогу, страх перед неизвестностью или отсутствие надежды. Возможно, вам не хватает оптимизма или вы чувствуете себя запертым в текущей ситуации. Это может указывать на пессимистический взгляд на будущее или нежелание что-либо менять."
    },
    { 
      code: "brown", 
      name: "Коричневый", 
      primary: false,
      first_interpretation: "Вы нуждаетесь в отдыхе, покое и физическом комфорте, возможно, чувствуете усталость. Вы хотите стабильности и защищенности. Этот цвет может указывать на физическую потребность в расслаблении, уходе от проблем, желание быть в тепле и безопасности. Может быть признаком истощения.",
      last_interpretation: "Вы отвергаете физический дискомфорт и ограничения, стремитесь к свободе от материальных забот. Возможно, вы чувствуете себя обремененным или загнанным в угол, ищете способы освободиться от бремени и ограничений."
    },
    { 
      code: "purple", 
      name: "Фиолетовый", 
      primary: false,
      first_interpretation: "Вы стремитесь к чему-то необычному, загадочному, возможно, идеализируете ситуацию или человека. Этот цвет часто выбирают люди с богатым воображением, чувствительные, стремящиеся к гармонии и избегающие конфликтов. Может указывать на некоторую инфантильность или нереалистичность взглядов.",
      last_interpretation: "Вы отвергаете иллюзии и мечтательность, стремитесь к ясности и реализму. Возможно, вы устали от неопределенности или чрезмерной чувствительности и ищете прагматичный подход к жизни."
    },
    { 
      code: "green", 
      name: "Зеленый", 
      primary: false,
      first_interpretation: "Вы чувствуете себя стабильно и уверенно, готовы отстаивать свои позиции. Есть потребность в признании и самоуважении. Этот цвет символизирует упорство, настойчивость и желание сохранить свои принципы.",
      last_interpretation: "Вы ощущаете потребность освободиться от давления и ограничений, возможно, чувствуете нехватку жизненной свободы. Может указывать на подавленную агрессию, нежелание отстаивать свои позиции или чувство, что вас не ценят."
    },
    { 
      code: "red", 
      name: "Красный", 
      primary: false,
      first_interpretation: "Вы ощущаете потребность в активных действиях, преодолении препятствий. Это символ жизненной силы.",
      last_interpretation: "Вы испытываете нехватку жизненной силы, возможно, чувствуете себя подавленным или истощенным. Это может указывать на подавленную агрессию, разочарование или чувство бессилия. Возможно, вам не хватает энергии или уверенности в себе."
    }
  ].freeze
  
  TOTAL_COLORS = 8
  
  attr_reader :bot_service, :user, :chat_id
  
  def initialize(bot_service, user, chat_id)
    @bot_service = bot_service
    @user = user
    @chat_id = chat_id
    @test = Test.luscher_test
  end
  
  # Начать тест
  def start_test
    unless @test
      log_error("Luscher test not found")
      send_test_not_found_message
      return false
    end
    
    # Очищаем незавершенные тесты
    cleanup_incomplete_tests
    
    # Создаем новый результат теста
    @test_result = create_test_result
    
    unless @test_result
      log_error("Failed to create test result")
      send_error_message("Ошибка при создании теста. Попробуйте позже.")
      return false
    end
    
    # Отправляем описание теста
    send_test_description
    
    # Отправляем изображения цветов
    send_color_images
    
    # Отправляем клавиатуру для выбора
    send_color_selection_keyboard
    
    true
  rescue => e
    log_error("Failed to start test", e)
    send_error_message("Произошла ошибка при запуске теста. Пожалуйста, попробуйте позже.")
    false
  end
  
  # Обработка выбора цвета
  def process_choice(callback_data)
    # Парсим callback_data
    color_code, test_result_id = parse_callback_data(callback_data)
    
    unless color_code && test_result_id
      log_error("Invalid callback data format: #{callback_data}")
      send_error_message("Неверный формат данных. Пожалуйста, начните тест заново.")
      return false
    end
    
    # Находим результат теста
    @test_result = find_test_result(test_result_id)
    
    unless valid_test_result?
      log_error("Invalid test result: #{test_result_id}")
      send_error_message("Тест Люшера неактивен или результат не найден. Пожалуйста, начните тест заново.")
      return false
    end
    
    # Добавляем выбранный цвет
    add_color_choice(color_code)
    
    # Проверяем, завершен ли тест
    if test_completed?
      complete_test
    else
      send_next_color_selection
    end
    
    true
  rescue => e
    log_error("Failed to process color choice", e, callback_data: callback_data)
    send_error_message("Ошибка при обработке выбора цвета. Пожалуйста, попробуйте еще раз.")
    false
  end
  
  # Показать интерпретацию
  def show_interpretation
    test_result = find_latest_test_result
    
    unless test_result
      log_error("No test results found for user")
      send_error_message("Результаты теста не найдены. Пожалуйста, пройдите тест сначала.")
      return false
    end
    
    choices = test_result.luscher_choices_array
    
    unless valid_choices?(choices)
      log_error("Invalid choices for interpretation", choices: choices)
      send_error_message("Тест Люшера еще не завершен или данные повреждены.")
      return false
    end
    
    # Формируем и отправляем интерпретацию
    send_interpretation(choices)
    
    true
  rescue => e
    log_error("Failed to show interpretation", e)
    send_error_message("Ошибка при получении интерпретации. Пожалуйста, попробуйте позже.")
    false
  end
  
  private
  
  # Очистка незавершенных тестов
  def cleanup_incomplete_tests
    TestResult.where(user: @user, test: @test, completed_at: nil).destroy_all
    log_info("Cleaned up incomplete Luscher tests")
  end
  
  # Создание результата теста
  def create_test_result
    test_result = TestResult.create!(
      user: @user,
      test: @test,
      luscher_choices: []
    )
    
    log_info("Created test result: #{test_result.id}")
    test_result
  rescue => e
    log_error("Failed to create test result", e)
    nil
  end
  
  # Отправка описания теста
  def send_test_description
    message = <<~MARKDOWN
      🎨 *Начинаем 8-ми цветовой тест Люшера*

      **Инструкция:**
      1. Посмотрите на все цвета ниже
      2. Выберите цвет, который вам сейчас больше всего нравится
      3. Нажмите на кнопку с названием этого цвета
      4. Продолжайте выбирать цвета в порядке предпочтения

      Всего нужно выбрать 8 цветов.
    MARKDOWN
    
    send_message(text: message, parse_mode: 'Markdown')
  end
  
  # Отправка изображений цветов
  def send_color_images
    shuffled_colors.each do |color|
      send_color_image(color)
    end
  end
  
  # Отправка изображения конкретного цвета
  def send_color_image(color)
    image_path = find_color_image(color[:code])
    
    if image_path
      send_photo(image_path, color[:name])
    else
      log_warn("Image not found for color: #{color[:name]}")
      send_color_description(color)
    end
  end
  
  # Отправка описания цвета (если нет изображения)
  def send_color_description(color)
    send_message(text: "🎨 #{color[:name]}")
  end
  
  # Отправка клавиатуры для выбора цвета
  def send_color_selection_keyboard
    available_colors = shuffled_colors
    markup = colors_keyboard(available_colors, @test_result.id)
    
    send_message(
      text: "Выберите наиболее приятный для вас цвет, нажав на кнопку ниже:",
      reply_markup: markup
    )
  end
  
  # Парсинг callback_data
  def parse_callback_data(callback_data)
    parts = callback_data.split('_')
    
    # Формат: luscher_color_COLORCODE_TESTRESULTID
    return nil unless parts.length >= 4
    return nil unless parts[0] == "luscher" && parts[1] == "color"
    
    # color_code может содержать подчеркивания (например, "dark_blue")
    # test_result_id всегда последний элемент
    test_result_id = parts.last.to_i
    
    # color_code - все между "luscher_color_" и "_#{test_result_id}"
    color_code_parts = parts.slice(2...-1)
    color_code = color_code_parts.join('_')
    
    [color_code, test_result_id]
  end
  
  # Поиск результата теста
  def find_test_result(test_result_id)
    TestResult.find_by(id: test_result_id)
  end
  
  # Проверка валидности результата теста
  def valid_test_result?
    @test_result &&
    @test_result.user == @user &&
    @test_result.test == @test &&
    @test_result.completed_at.nil?
  end
  
  # Добавление выбранного цвета
  def add_color_choice(color_code)
    choices = @test_result.luscher_choices_array
    
    unless choices.include?(color_code)
      choices << color_code
      @test_result.update(luscher_choices: choices)
      log_info("Added color choice: #{color_code}, choices: #{choices}")
    end
  end
  
  # Проверка завершения теста
  def test_completed?
    @test_result.luscher_choices_array.length >= TOTAL_COLORS
  end
  
  # Завершение теста
  def complete_test
    @test_result.update(completed_at: Time.current)
    send_completion_message
    log_info("Test completed: #{@test_result.id}")
  end
  
  # Отправка сообщения о завершении
  def send_completion_message
    message = <<~MARKDOWN
      ✅ *Отлично! Вы завершили выбор цветов.*

      Теперь я попробую дать вам небольшую интерпретацию ваших результатов.
    MARKDOWN
    
    send_message(
      text: message,
      parse_mode: 'Markdown',
      reply_markup: TelegramMarkupHelper.luscher_test_completed_markup
    )
  end
  
  # Отправка следующего выбора цвета
  def send_next_color_selection
    available_colors = get_available_colors
    remaining = TOTAL_COLORS - @test_result.luscher_choices_array.length
    
    message = <<~MARKDOWN
      Выбрано цветов: #{@test_result.luscher_choices_array.length}/#{TOTAL_COLORS}
      
      Выберите следующий наиболее приятный цвет:
    MARKDOWN
    
    # Отправляем изображения оставшихся цветов
    available_colors.each do |color|
      send_color_image(color)
    end
    
    markup = colors_keyboard(available_colors, @test_result.id)
    
    send_message(
      text: message,
      reply_markup: markup
    )
  end
  
  # Получение доступных цветов (еще не выбранных)
  def get_available_colors
    chosen_colors = @test_result.luscher_choices_array
    COLOURS.reject { |color| chosen_colors.include?(color[:code]) }
  end
  
  # Поиск последнего результата теста
  def find_latest_test_result
    TestResult.where(user: @user, test: @test)
              .order(created_at: :desc)
              .first
  end
  
  # Проверка валидности выбранных цветов
  def valid_choices?(choices)
    choices.is_a?(Array) && choices.length == TOTAL_COLORS
  end
  
  # Отправка интерпретации
  def send_interpretation(choices)
    first_color = find_color_by_code(choices.first)
    last_color = find_color_by_code(choices.last)
    
    unless first_color && last_color
      log_error("Failed to find colors for interpretation", choices: choices)
      send_error_message("Не удалось найти интерпретацию для выбранных цветов.")
      return
    end
    
    interpretation = build_interpretation(first_color, last_color)
    
    send_message(
      text: interpretation,
      parse_mode: 'Markdown',
      reply_markup: TelegramMarkupHelper.back_to_main_menu_markup
    )
  end
  
  # Поиск цвета по коду
  def find_color_by_code(code)
    COLOURS.find { |color| color[:code] == code }
  end
  
  # Построение интерпретации
  def build_interpretation(first_color, last_color)
    <<~MARKDOWN
      ✨ **Ваши результаты 8-ми цветового теста Люшера** ✨

      *Первый выбранный цвет: #{first_color[:name]}*
      #{first_color[:first_interpretation]}

      *Последний выбранный цвет: #{last_color[:name]}*
      #{last_color[:last_interpretation]}

      ---
      *Примечание:* Это упрощенная интерпретация. Для полного анализа рекомендуется консультация психолога.
    MARKDOWN
  end
  
  # Перемешанные цвета
  def shuffled_colors
    COLOURS.shuffle
  end
  
  # Поиск изображения цвета
  def find_color_image(color_code)
    file_mask = Rails.root.join('public', 'assets', "#{color_code}-*.jpeg")
    image_files = Dir.glob(file_mask)
    image_files.first if image_files.any?
  end
  
  # Клавиатура с цветами
  def colors_keyboard(colors, test_result_id)
    buttons = colors.map do |color|
      {
        text: color[:name],
        callback_data: "luscher_color_#{color[:code]}_#{test_result_id}"
      }
    end
    
    # Разбиваем на строки по 2 кнопки
    inline_keyboard = buttons.each_slice(2).to_a
    
    { inline_keyboard: inline_keyboard }.to_json
  end
  
  # Отправка сообщения
  def send_message(text:, reply_markup: nil, parse_mode: nil)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text,
      reply_markup: reply_markup,
      parse_mode: parse_mode
    )
  end
  
  # Отправка фото
  def send_photo(photo_path, caption = nil)
    File.open(photo_path, 'r') do |file|
      @bot_service.bot.send_photo(
        chat_id: @chat_id,
        photo: file,
        caption: caption
      )
    end
  rescue => e
    log_error("Failed to send photo: #{photo_path}", e)
    nil
  end
  
  # Отправка сообщения об ошибке
  def send_error_message(text = "Произошла ошибка. Пожалуйста, попробуйте позже.")
    send_message(text: text)
  end
  
  # Отправка сообщения о ненайденном тесте
  def send_test_not_found_message
    send_message(text: "Тест Люшера не найден.")
  end
  
  # Логирование
  def log_info(message, extra = {})
    Rails.logger.info "[LuscherTestService] #{message} - User: #{@user.telegram_id}, #{extra.to_json}"
  end
  
  def log_error(message, error = nil, extra = {})
    Rails.logger.error "[LuscherTestService] #{message} - User: #{@user.telegram_id}, #{extra.to_json}"
    Rails.logger.error error.message if error
    Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
  end
  
  def log_warn(message, extra = {})
    Rails.logger.warn "[LuscherTestService] #{message} - User: #{@user.telegram_id}, #{extra.to_json}"
  end
end