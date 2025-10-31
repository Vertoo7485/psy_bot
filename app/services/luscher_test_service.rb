
# app/services/luscher_test_service.rb
class LuscherTestService
  include TelegramMarkupHelper # Для генерации клавиатур

  # Константа COLOURS перенесена сюда
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

  def initialize(bot, user, chat_id)
    @bot = bot
    @user = user
    @chat_id = chat_id
    @test = Test.luscher_test # Используем новый scope
  end

  def start_test
    return @bot.send_message(chat_id: @chat_id, text: "Тест Люшера не найден.") unless @test

    # Удаляем все незаконченные тесты
    TestResult.where(user: @user, test: @test, completed_at: nil).destroy_all

    test_result = TestResult.create(user: @user, test: @test, luscher_choices: [])
    available_colors = COLOURS.shuffle

    @bot.send_message(chat_id: @chat_id, text: "Начинаем 8-ми цветовой тест Люшера. Выберите цвет, который вам сейчас больше всего нравится:")

    available_colors.each do |color|
      send_color_image_with_name(color)
    end

    markup = luscher_colors_keyboard(available_colors)
    @bot.send_message(chat_id: @chat_id, text: "Выберите наиболее приятный для вас цвет, нажав на кнопку ниже:", reply_markup: markup)
  end

  def process_choice(color_code, message_id)
    test_result = TestResult.find_by(user: @user, test: @test, completed_at: nil)
    return @bot.send_message(chat_id: @chat_id, text: "Тест Люшера не активен. Начните заново.") unless test_result

    test_result.luscher_choices ||= [] # Инициализируем, если nil
    test_result.luscher_choices << color_code
    test_result.save!

    available_colors = COLOURS.reject { |c| test_result.luscher_choices.include?(c[:code]) }

    if available_colors.empty?
      test_result.update(completed_at: Time.now)
      @bot.send_message(
        chat_id: @chat_id,
        text: "Отлично! Ты завершил тест! Теперь я попробую дать тебе небольшую интерпретацию твоих результатов.",
        reply_markup: luscher_interpretation_markup
      )
    else
      @bot.send_message(chat_id: @chat_id, text: "Выбери следующий цвет:")
      available_colors.each do |color|
        send_color_image_with_name(color)
      end
      markup = luscher_colors_keyboard(available_colors.shuffle)
      @bot.send_message(chat_id: @chat_id, text: "Выберите цвет, нажав на кнопку ниже:", reply_markup: markup)
    end
  end

  def show_interpretation
    test_result = TestResult.where(user: @user, test: @test).order(created_at: :desc).first
    return @bot.send_message(chat_id: @chat_id, text: "Результаты теста не найдены.") unless test_result

    choices = test_result.luscher_choices

    if choices.nil? || choices.length < COLOURS.length
      @bot.send_message(chat_id: @chat_id, text: "Тест Люшера еще не завершен или данные повреждены. Недостаточно цветов для интерпретации.")
      return
    end

    first_color_data = COLOURS.find { |c| c[:code] == choices.first }
    last_color_data = COLOURS.find { |c| c[:code] == choices.last }

    if first_color_data && last_color_data
      interpretation_message = "✨ **Ваши результаты 8-ми цветового теста Люшера** ✨\n\n"
      interpretation_message += "  _Интерпретация первого выбранного цвета:_ #{first_color_data[:first_interpretation]}\n\n"
      interpretation_message += "  _Интерпретация последнего выбранного цвета:_ #{last_color_data[:last_interpretation]}\n\n"
      interpretation_message += "---"
      @bot.send_message(chat_id: @chat_id, text: interpretation_message, parse_mode: 'Markdown', reply_markup: back_to_main_menu_markup)
    else
      @bot.send_message(chat_id: @chat_id, text: "Не удалось найти интерпретацию для выбранных цветов. Пожалуйста, попробуйте еще раз или свяжитесь с администратором.", reply_markup: back_to_main_menu_markup)
    end
  end

  private

  def send_color_image_with_name(color)
    # Предполагаем, что изображения находятся в public/assets и их имена соответствуют color[:code]
    # Например: public/assets/dark_blue-abcdef123.jpeg
    # В production Rails обычно добавляет хэш к имени файла.
    # Для простоты, мы ищем файл по маске. В реальном приложении лучше использовать CDN
    # или более надежный способ получения URL ассета.

    # Для локальной разработки, если файлы просто в public/images:
    # image_path = Rails.root.join('public', 'images', "#{color[:code]}.jpeg")

    # Для precompiled assets (как в вашем коде):
    file_mask = Rails.root.join('public', 'assets', "#{color[:code]}-*.jpeg")
    image_files = Dir.glob(file_mask)

    if image_files.any?
      image_path = image_files.first
      Rails.logger.info "Найден файл изображения: #{image_path}"
      File.open(image_path, 'r') do |file|
        @bot.send_photo(chat_id: @chat_id, photo: file, caption: color[:name])
      end
    else
      Rails.logger.error "Файл изображения не найден для цвета: #{color[:name]} по маске #{file_mask}"
      @bot.send_message(chat_id: @chat_id, text: "Изображение для цвета '#{color[:name]}' не найдено.")
    end
  rescue => e
    Rails.logger.error "Ошибка при отправке изображения: #{e.message}"
    @bot.send_message(chat_id: @chat_id, text: "Произошла ошибка при отправке изображения для цвета '#{color[:name]}'.")
  end
end