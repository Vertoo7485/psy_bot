
# app/services/luscher_test_service.rb
class LuscherTestService
  # Если ты хочешь использовать методы из TelegramMarkupHelper,
  # их нужно вызывать через TelegramMarkupHelper.имя_метода
  # Если ты хочешь, чтобы методы LuscherTestService были доступны через `include`,
  # то можно убрать include и использовать `self.class.метод` для своих методов модуля.

  # Константа COLOURS
  COLOURS = [
    { code: "dark_blue", name: "Темно-синий", primary: true,
      first_interpretation: "Ваша потребность в покое и удовлетворенности реализована. Вы не стремитесь к изменениям и довольны существующим положением дел. Если этот цвет был выбран одним из первых, это указывает на стремление к комфорту, порядку и эмоциональной стабильности. Вы ищете гармонии и защищенности.",
      last_interpretation: "Вы испытываете нехватку спокойствия и удовлетворенности, возможно, чувствуете напряжение или неудовлетворенность существующей ситуацией. Вам может не хватать порядка и эмоциональной стабильности, вы ищете способ избежать дискомфорта."
    },
    { code: "blue_green", name: "Сине-зеленый", primary: true,
      first_interpretation: "Вы стремитесь утвердить себя и свои принципы, чувствуете себя уверенно и можете сопротивляться внешнему давлению. Этот цвет символизирует настойчивость и стремление к самоконтролю. Если он выбран в начале, это говорит о желании утвердить свою правоту и быть признанным.",
      last_interpretation: "Вы чувствуете, что не можете утвердить себя, испытываете неуверенность или внутреннее сопротивление. Возможно, вам не хватает самоконтроля или вы ощущаете внешнее давление, с которым трудно справиться."
    },
    { code: "red_yellow", name: "Оранжево-красный", primary: true,
      first_interpretation: "Вы испытываете эмоциональное возбуждение, жажду активности, силы и энергии. Ваша жизнеспособность высока, и вы готовы к действию. Вы стремитесь к успеху и хотите получить от жизни максимум. Этот цвет говорит о потребности в волнении, сильных переживаниях и страстности.",
      last_interpretation: "Вы испытываете упадок энергии, разочарование или подавленность. Возможно, вам не хватает жизненной силы или вы ощущаете бессилие перед лицом препятствий. Это может указывать на усталость от постоянных требований и необходимость в отдыхе."
    },
    { code: "yellow", name: "Желтый", primary: true,
      first_interpretation: "Вы ищете освобождения от трудностей и препятствий, стремитесь к счастью, свободе и новым возможностям. Вы открыты для приключений и перемен. Этот цвет означает оптимизм, надежду и потребность в личностном росте и развитии. Вы готовы к новым начинаниям.",
      last_interpretation: "Вы ощущаете тревогу, страх перед неизвестностью или отсутствие надежды. Возможно, вам не хватает оптимизма или вы чувствуете себя запертым в текущей ситуации. Это может указывать на пессимистический взгляд на будущее или нежелание что-либо менять."
    },
    { code: "brown", name: "Коричневый", primary: false,
      first_interpretation: "Вы нуждаетесь в отдыхе, покое и физическом комфорте, возможно, чувствуете усталость. Вы хотите стабильности и защищенности. Этот цвет может указывать на физическую потребность в расслаблении, уходе от проблем, желание быть в тепле и безопасности. Может быть признаком истощения.",
      last_interpretation: "Вы отвергаете физический дискомфорт и ограничения, стремитесь к свободе от материальных забот. Возможно, вы чувствуете себя обремененным или загнанным в угол, ищете способы освободиться от бремени и ограничений."
    },
    { code: "purple", name: "Фиолетовый", primary: false,
      first_interpretation: "Вы стремитесь к чему-то необычному, загадочному, возможно, идеализируете ситуацию или человека. Этот цвет часто выбирают люди с богатым воображением, чувствительные, стремящиеся к гармонии и избегающие конфликтов. Может указывать на некоторую инфантильность или нереалистичность взглядов.",
      last_interpretation: "Вы отвергаете иллюзии и мечтательность, стремитесь к ясности и реализму. Возможно, вы устали от неопределенности или чрезмерной чувствительности и ищете прагматичный подход к жизни."
    },
    { code: "green", name: "Зеленый", primary: false,
      first_interpretation: "Вы чувствуете себя стабильно и уверенно, готовы отстаивать свои позиции. Есть потребность в признании и самоуважении. Этот цвет символизирует упорство, настойчивость и желание сохранить свои принципы.",
      last_interpretation: "Вы ощущаете потребность освободиться от давления и ограничений, возможно, чувствуете нехватку жизненной свободы. Может указывать на подавленную агрессию, нежелание отстаивать свои позиции или чувство, что вас не ценят."
    },
    { code: "red", name: "Красный", primary: false,
      first_interpretation: "Вы ощущаете потребность в активных действиях, преодолении препятствий. Это символ жизненной силы.",
      last_interpretation: "Вы испытываете нехватку жизненной силы, возможно, чувствуете себя подавленным или истощенным. Это может указывать на подавленную агрессию, разочарование или чувство бессилия. Возможно, вам не хватает энергии или уверенности в себе."
    }
  ].freeze

  # Метод для генерации клавиатуры с цветами (предполагаем, что он находится здесь)
  def self.luscher_colors_keyboard(available_colors, test_result_id)
    buttons = available_colors.map do |color|
      # Формируем callback_data, который позволит идентифицировать цвет и результат теста
      { text: color[:name], callback_data: "luscher_color_#{color[:code]}_#{test_result_id}" }
    end
    # Разбиваем кнопки на строки по 2
    inline_keyboard = buttons.each_slice(2).map do |row_buttons|
      row_buttons
    end
    { inline_keyboard: inline_keyboard }.to_json
  end

  # Метод для генерации кнопки "Назад" (или для возврата в главное меню)
  def self.back_to_main_menu_markup
    {
      inline_keyboard: [
        [{ text: "⬅️ Назад в главное меню", callback_data: "back_to_main_menu" }]
      ]
    }.to_json
  end

  def initialize(bot_service, user, chat_id)
    @bot_service = bot_service
    @bot = bot_service.bot
    @user = user
    @chat_id = chat_id
    @test = Test.luscher_test # Используем новый scope
    @test_result = nil # Будет заполняться при старте теста
  end

  def start_test
    return @bot_service.send_message(chat_id: @chat_id, text: "Тест Люшера не найден.") unless @test

    # Удаляем все незаконченные тесты для этого пользователя и этого теста
    TestResult.where(user: @user, test: @test, completed_at: nil).destroy_all

    # Создаем новый результат теста
    @test_result = TestResult.create!(user: @user, test: @test, luscher_choices: [])

    # Отправляем первое сообщение с описанием
    @bot_service.send_message(
      chat_id: @chat_id,
      text: "Начинаем 8-ми цветовой тест Люшера. Выберите цвет, который вам сейчас больше всего нравится:"
    )

    # Перемешиваем цвета для случайного порядка
    available_colors = COLOURS.shuffle

    # Отправляем картинки цветов
    available_colors.each do |color|
      send_color_image_with_name(color)
    end

    # Отправляем клавиатуру с кнопками выбора цветов
    markup = self.class.luscher_colors_keyboard(available_colors, @test_result.id)
    @bot_service.send_message(chat_id: @chat_id, text: "Выберите наиболее приятный для вас цвет, нажав на кнопку ниже:", reply_markup: markup)
  end

  # Обработка выбора цвета пользователем
  def process_choice(callback_data)
        # Парсим callback_data, ожидаем формат "luscher_color_КОД_цвета_ID_результата"
        # Пример: "luscher_color_brown_119" или "luscher_color_dark_blue_119"
        parts = callback_data.split('_')
        # parts будет: ["luscher", "color", "brown", "119"] (для "brown")
        # или ["luscher", "color", "dark", "blue", "119"] (для "dark_blue") - вот тут проблема!

        # Учитываем, что code может содержать '_' (например, "dark_blue")
        # Поэтому нужно найти test_result_id в конце и остальное считать кодом цвета.
        # test_result_id всегда будет последним элементом.
        test_result_id = parts.last.to_i
        # color_code - это все, что между "luscher_color_" и "_#{test_result_id}"
        # Например, для "luscher_color_dark_blue_119" -> "dark_blue"
        # parts[0] == "luscher", parts[1] == "color"
        # parts.slice(2...-1) соберет код цвета
        color_code_parts = parts.slice(2...-1)
        color_code = color_code_parts.join('_')

        # Теперь проверим, что парсинг успешен и соответствует ожиданиям.
        unless parts[0] == "luscher" && parts[1] == "color" && test_result_id > 0 && !color_code.empty?
          return send_error_message("Неверный формат callback_data для теста Люшера: #{callback_data}")
        end

        @test_result = TestResult.find_by(id: test_result_id)

    Rails.logger.debug "LuscherTestService: Debugging process_choice for test_result_id: #{test_result_id}"
    Rails.logger.debug "  @test_result: #{@test_result.inspect}"
    Rails.logger.debug "  @user: #{@user.inspect}"
    Rails.logger.debug "  @test_result.user: #{@test_result&.user.inspect}"
    Rails.logger.debug "  @test_result.test: #{@test_result&.test.inspect}"
    Rails.logger.debug "  @test_result.test&.test_type: #{@test_result&.test&.test_type.inspect}" # Это "luscher"
    Rails.logger.debug "  @test_result.completed_at: #{@test_result&.completed_at.inspect}"
    Rails.logger.debug "  Comparison test_result.user == @user: #{(@test_result&.user == @user)}"
    # ИЗМЕНЕНИЕ ЗДЕСЬ: сравниваем строку со строкой
    Rails.logger.debug "  Comparison test_result.test&.test_type == 'luscher': #{(@test_result&.test&.test_type == 'luscher')}"
    Rails.logger.debug "  Comparison test_result.completed_at.nil?: #{(@test_result&.completed_at.nil?)}"

    unless @test_result &&
           @test_result.user == @user &&
           @test_result.test&.test_type == 'luscher' && # <-- ИЗМЕНЕНО: теперь сравниваем со строкой 'luscher'
           @test_result.completed_at.nil?
      Rails.logger.warn "LuscherTestService: TestResult #{test_result_id} is invalid for processing. One or more conditions failed."
      return send_error_message("Тест Люшера неактивен или результат не найден. Пожалуйста, начните тест заново.")
    end

        # Добавляем выбранный цвет, если его еще нет (защита от повторных нажатий)
        @test_result.luscher_choices ||= []
        unless @test_result.luscher_choices.include?(color_code)
          @test_result.luscher_choices << color_code
          @test_result.save!
        end

        available_colors = COLOURS.reject { |c| @test_result.luscher_choices.include?(c[:code]) }

        if available_colors.empty?
          # Тест завершен (выбраны все 8 цветов)
          @test_result.update(completed_at: Time.now)
          send_interpretation_intro
        else
          # Отправляем следующее сообщение с выбором следующих цветов
          @bot_service.send_message(chat_id: @chat_id, text: "Выберите следующий наиболее приятный цвет:")

          # Отправляем картинки только тех цветов, которые ЕЩЕ НЕ были выбраны
          available_colors.each do |color|
            send_color_image_with_name(color)
          end

          markup = self.class.luscher_colors_keyboard(available_colors, @test_result.id)
          @bot_service.send_message(chat_id: @chat_id, text: "Выберите цвет, нажав на кнопку ниже:", reply_markup: markup)
        end
  end

  # Отправка сообщения перед показом интерпретации
  def send_interpretation_intro
    @bot_service.send_message(
      chat_id: @chat_id,
      text: "Отлично! Ты завершил выбор цветов. Теперь я попробую дать тебе небольшую интерпретацию твоих результатов.",
      reply_markup: TelegramMarkupHelper.luscher_test_completed_markup # Возврат в главное меню
    )
  end

  # Показывает интерпретацию результатов теста
  def show_interpretation
    test_result = TestResult.where(user: @user, test: @test).order(created_at: :desc).first
    return @bot_service.send_message(chat_id: @chat_id, text: "Результаты теста не найдены.") unless test_result

    choices = test_result.luscher_choices

    if choices.nil? || choices.length < COLOURS.length
      @bot_service.send_message(chat_id: @chat_id, text: "Тест Люшера еще не завершен или данные повреждены. Недостаточно цветов для интерпретации.")
      return
    end

    # Находим данные для первого и последнего выбранных цветов
    first_color_data = COLOURS.find { |c| c[:code] == choices.first }
    last_color_data = COLOURS.find { |c| c[:code] == choices.last }

    if first_color_data && last_color_data
      interpretation_message = "✨ **Ваши результаты 8-ми цветового теста Люшера** ✨\n\n"
      interpretation_message += "  _Интерпретация первого выбранного цвета:_ #{first_color_data[:first_interpretation]}\n\n"
      interpretation_message += "  _Интерпретация последнего выбранного цвета:_ #{last_color_data[:last_interpretation]}\n\n"
      interpretation_message += "---"
      @bot_service.send_message(chat_id: @chat_id, text: interpretation_message, parse_mode: 'Markdown', reply_markup: self.class.back_to_main_menu_markup)
    else
      @bot_service.send_message(chat_id: @chat_id, text: "Не удалось найти интерпретацию для выбранных цветов. Пожалуйста, попробуйте еще раз или свяжитесь с администратором.", reply_markup: self.class.back_to_main_menu_markup)
    end
  end

  private

  # Отправляет картинку цвета с его названием
  def send_color_image_with_name(color)
    # Ищем файл изображения по маске в папке public/assets
    # Пример: public/assets/dark_blue-abcdef123.jpeg
    file_mask = Rails.root.join('public', 'assets', "#{color[:code]}-*.jpeg")
    image_files = Dir.glob(file_mask)

    if image_files.any?
      image_path = image_files.first
      Rails.logger.info "Найден файл изображения: #{image_path}"
      begin
        File.open(image_path, 'r') do |file|
          @bot_service.bot.send_photo(chat_id: @chat_id, photo: file, caption: color[:name])
        end
      rescue Telegram::Bot::Error => e
        Rails.logger.error "Telegram API Error при отправке изображения #{color[:name]}: #{e.message}"
        @bot_service.send_message(chat_id: @chat_id, text: "Произошла ошибка при отправке изображения для цвета '#{color[:name]}'.")
      rescue => e
        Rails.logger.error "Неизвестная ошибка при отправке изображения #{color[:name]}: #{e.message}"
        @bot_service.send_message(chat_id: @chat_id, text: "Произошла непредвиденная ошибка при отправке изображения для цвета '#{color[:name]}'.")
      end
    else
      Rails.logger.error "Файл изображения не найден для цвета: #{color[:name]} по маске #{file_mask}"
      @bot_service.send_message(chat_id: @chat_id, text: "Изображение для цвета '#{color[:name]}' не найдено. Возможно, файл отсутствует или имеет другое расширение.")
    end
  end

  # Вспомогательный метод для отправки сообщений об ошибках
  def send_error_message(text)
    @bot_service.send_message(chat_id: @chat_id, text: text)
  end
end