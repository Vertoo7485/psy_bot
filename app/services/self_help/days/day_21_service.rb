# app/services/self_help/days/day21_service.rb

module SelfHelp
  module Days
    class Day21Service < DayBaseService
      include TelegramMarkupHelper
      
      # ===== КОНСТАНТЫ ДНЯ 21 =====
      DAY_NUMBER = 21
      
      # Шаги дня 21
      DAY_STEPS = {
        'intro' => {
          title: "🏆 *День 21: Рефлексия 3 недель практики* 🧠",
          instruction: <<~MARKDOWN
            **Поздравляем с завершением 3 недель программы!** 🎉

            **21 день — это важная веха в формировании привычек:**

            📊 **Научные факты о 21 дне:**
            • 🧠 **Нейропластичность:** За 21 день мозг формирует устойчивые нейронные связи для новых привычек
            • 📈 **Исследования:** Участники программ с рефлексией на 21-й день на 40% чаще продолжали практику
            • 💫 **Эффект накопления:** Три недели регулярной практики создают достаточный импульс для долгосрочных изменений
            • 🎯 **Критическая точка:** После 21 дня новая привычка начинает требовать меньше сознательных усилий

            **Ваш путь за 3 недели:**
            • Неделя 1: Освоение основ осознанности, эмоционального интеллекта и дыхательных техник
            • Неделя 2: Работа с мышлением, прокрастинацией, самосостраданием и заземлением
            • Неделя 3: Преодоление страхов, восстановление связей, доброта к себе и медитация
            • 🧠 **21 различных техник** и практик освоено
            • 💪 **Значительный прогресс** в самопонимании и саморегуляции

            **Сегодняшняя цель:** Осознать и интегрировать весь 3-недельный опыт, создать прочную основу для дальнейшего развития.
          MARKDOWN
        },
        'exercise_explanation' => {
          title: "📖 *Упражнение: Глубинная рефлексия 21 дня* 💭",
          instruction: <<~MARKDOWN
            **Почему рефлексия на 21 день так важна?** 🌟

            • 🔄 **Нейробиологический эффект:** Активирует дефолт-систему мозга для интеграции опыта и консолидации памяти
            • 🧠 **Когнитивная польза:** Укрепляет метапознание — способность думать о своем мышлении и процессе обучения
            • 😌 **Эмоциональная интеграция:** Помогает осознать и ассимилировать весь спектр эмоциональных переживаний
            • 🎯 **Стратегическое планирование:** Позволяет создать персональную систему практик на основе полученного опыта
            • 🌱 **Мотивация и устойчивость:** Восстанавливает энергетические ресурсы и создает фундамент для долгосрочных изменений

            **«Мы не учимся на опыте. Мы учимся, размышляя об опыте.»** — Джон Дьюи

            **Сегодняшнее упражнение:** Глубинная интеграция всего 3-недельного опыта.
            Цель — создать целостную картину прогресса и план интеграции в жизнь.
          MARKDOWN
        }
      }.freeze
      
      # Категории рефлексии для 3 недель
      REFLECTION_CATEGORIES = [
        {
          id: 0,
          name: "Основные трансформации",
          emoji: "🌟",
          description: "Какие главные изменения произошли в вас за 3 недели?",
          prompt: <<~PROMPT
            🌟 *Основные трансформации 21 дня:*

            • Как изменилось ваше **эмоциональное состояние** в целом?
            • Что стало иначе в вашем **мышлении и восприятии** себя?
            • Какие **поведенческие изменения** вы заметили в повседневной жизни?
            • Как изменилось ваше **отношение к трудностям и вызовам**?

            *Напишите о главных изменениях, которые произошли в вас за 21 день:* 📝
          PROMPT
        },
        {
          id: 1,
          name: "Наиболее ценные техники",
          emoji: "💎",
          description: "Какие инструменты стали самыми полезными и почему?",
          prompt: <<~PROMPT
            💎 *Наиболее ценные техники 3 недель:*

            • Какие **2-3 техники** оказались самыми эффективными лично для вас?
            • Почему именно они сработали лучше всего?
            • Как эти техники **интегрировались в вашу повседневность**?
            • Что они дали вам на **практическом уровне** (спокойствие, ясность, энергию)?

            *Опишите ваши самые ценные инструменты и их воздействие:* 📝
          PROMPT
        },
        {
          id: 2,
          name: "Ключевые инсайты о себе",
          emoji: "🔍",
          description: "Что нового вы узнали о себе в процессе?",
          prompt: <<~PROMPT
            🔍 *Ключевые инсайты о себе:*

            • Какие **паттерны мышления** или **эмоциональные реакции** обнаружили?
            • Какие **внутренние ресурсы** и **сильные стороны** открыли в себе?
            • Что стало самым **неожиданным открытием** о себе?
            • Как изменилось ваше **понимание собственных потребностей**?

            *Напишите о самых важных открытиях, которые сделали о себе:* 📝
          PROMPT
        },
        {
          id: 3,
          name: "Преодоленные барьеры",
          emoji: "🚀",
          description: "Какие внутренние сопротивления вы преодолели?",
          prompt: <<~PROMPT
            🚀 *Преодоленные барьеры и сопротивления:*

            • С какими **внутренними сопротивлениями** столкнулись (лень, сомнения, страх)?
            • Как **изменилось ваше отношение** к этим сопротивлениям?
            • Какие **стратегии** помогали вам продолжать в трудные моменты?
            • Что вы **узнали о своей устойчивости** и настойчивости?

            *Опишите, как преодолевали внутренние барьеры:* 📝
          PROMPT
        },
        {
          id: 4,
          name: "План интеграции в жизнь",
          emoji: "🗺️",
          description: "Как вы будете продолжать практику в повседневной жизни?",
          prompt: <<~PROMPT
            🗺️ *План интеграции в повседневную жизнь:*

            • Какие техники войдут в ваш **ежедневный/еженедельный ритуал**?
            • Как будете **поддерживать прогресс** и **предотвращать откаты**?
            • Какие **конкретные цели** ставите на следующие 30/60/90 дней?
            • Как будете **отслеживать** и **отмечать** свой прогресс?

            *Напишите ваш персональный план интеграции практик в жизнь:* 📝
          PROMPT
        },
        {
          id: 5,
          name: "Цели дальнейшего развития",
          emoji: "🎯",
          description: "Куда вы хотите двигаться дальше в своем развитии?",
          prompt: <<~PROMPT
            🎯 *Цели дальнейшего развития:*

            • В каких **навыках** хотите развиваться дальше?
            • Какие **области жизни** хотите улучшить с помощью этих практик?
            • Какой вы видите себя через **3-6 месяцев** регулярной практики?
            • Какие **ресурсы и поддержка** вам понадобятся для продолжения пути?

            *Опишите ваши цели и видение дальнейшего развития:* 📝
          PROMPT
        }
      ].freeze
      
      # Цитаты для мотивации
      MOTIVATIONAL_QUOTES = [
        "«21 день — это не конец пути, а начало новой привычки быть счастливее и осознаннее.»",
        "«Самые значительные изменения часто происходят незаметно, пока однажды ты не осознаешь, что стал другим человеком.»",
        "«Терпение с самим собой — это высшая форма самосострадания и мудрости.»",
        "«Маленькие шаги, повторяемые ежедневно, создают большие изменения в нейронах и в жизни.»"
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Показываем статистику 3 недель
        send_message(
          text: three_weeks_statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы к глубинной рефлексии 3 недель практики?",
          reply_markup: day_21_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        # Добавляем мотивационную цитату
        send_message(
          text: "*#{MOTIVATIONAL_QUOTES.sample}*",
          parse_mode: 'Markdown'
        )
        
        # Инициализируем процесс рефлексии
        init_reflection_process
      end
      
      def init_reflection_process
        # Сбрасываем прогресс рефлексии
        store_day_data('reflection_progress', {
          current_category_index: 0,
          completed_categories: [],
          reflections: {},
          start_time: Time.current
        })
        
        # Показываем первую категорию
        show_next_reflection_category
      end
      
      def show_next_reflection_category
        progress = get_reflection_progress
        current_index = progress[:current_category_index]
        
        if current_index >= REFLECTION_CATEGORIES.size
          # Все категории пройдены
          complete_reflection_process
          return
        end
        
        category = REFLECTION_CATEGORIES[current_index]
        
        # Показываем прогресс
        show_reflection_progress(current_index)
        
        # Показываем категорию с подробными инструкциями
        send_message(
          text: category_prompt_with_progress(category, current_index),
          parse_mode: 'Markdown',
          reply_markup: day_21_category_options_markup(current_index)
        )
        
        # Устанавливаем состояние ожидания ввода
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_reflection_#{current_index}")
      end
      
      def handle_reflection_text(input_text, category_index)
  return false if input_text.blank?
  
  # Проверяем минимальную длину
  if input_text.length < 20
    send_message(
      text: "Пожалуйста, напишите более развернутый ответ (минимум 20 символов).",
      parse_mode: 'Markdown'
    )
    return false
  end
  
  # Сохраняем рефлексию
  progress = get_reflection_progress
  progress[:reflections][category_index.to_s] = {
    text: input_text,
    timestamp: Time.current,
    length: input_text.length,
    category_name: REFLECTION_CATEGORIES[category_index][:name]
  }
  
  # Отмечаем категорию как завершенную
  progress[:completed_categories] << category_index unless progress[:completed_categories].include?(category_index)
  
  # Переходим к следующей категории
  progress[:current_category_index] = category_index + 1
  
  save_reflection_progress(progress)
  
  # Логируем для отладки
  log_info("Saved reflection for category #{category_index}: #{input_text.truncate(50)}")
  log_info("Current progress: #{progress.inspect}")
  
  # Подтверждаем сохранение
  send_message(
    text: "✅ Сохранено! #{category_emoji(category_index)} Рефлексия по категории *#{REFLECTION_CATEGORIES[category_index][:name]}* сохранена.",
    parse_mode: 'Markdown'
  )
  
  # Автоматически переходим к следующей категории
  if progress[:current_category_index] < REFLECTION_CATEGORIES.size
    sleep(1) # Небольшая пауза
    show_next_reflection_category
  else
    complete_reflection_process
  end
  
  true
end

def debug_reflection_data
  progress = get_reflection_progress
  
  message = "🔍 *Отладка данных рефлексии:*\n\n"
  message += "• Категорий завершено: #{progress[:completed_categories].size}\n"
  message += "• Текущий индекс: #{progress[:current_category_index]}\n"
  message += "• Время начала: #{progress[:start_time]}\n\n"
  
  if progress[:reflections].empty?
    message += "📭 *Нет сохраненных рефлексий*\n"
  else
    message += "📝 *Сохраненные рефлексии:*\n"
    progress[:reflections].each do |cat_id, reflection|
      message += "• Категория #{cat_id}: #{reflection[:text]&.truncate(30) || 'пусто'}\n"
    end
  end
  
  send_message(text: message, parse_mode: 'Markdown')
end
      
      def skip_category(category_index)
        progress = get_reflection_progress
        
        # Пропускаем категорию
        progress[:current_category_index] = category_index + 1
        save_reflection_progress(progress)
        
        send_message(
          text: "⏭️ Пропущено: #{category_emoji(category_index)} *#{REFLECTION_CATEGORIES[category_index][:name]}*",
          parse_mode: 'Markdown'
        )
        
        # Переходим к следующей категории
        if progress[:current_category_index] < REFLECTION_CATEGORIES.size
          show_next_reflection_category
        else
          complete_reflection_process
        end
      end
      
      def complete_reflection_process
        progress = get_reflection_progress
        completed_count = progress[:completed_categories].size
        
        send_message(
          text: completion_summary_message(completed_count),
          parse_mode: 'Markdown'
        )
        
        # Сохраняем полную рефлексию
        save_three_weeks_reflection_entry
        
        # Показываем предварительный обзор
        show_reflection_preview
        
        # Переходим к вопросам о трудностях
        sleep(2)
        show_reflection_challenges
      end
      
      def show_reflection_preview
        progress = get_reflection_progress
        
        if progress[:completed_categories].empty?
          send_message(
            text: "📭 Вы пропустили все категории рефлексии.",
            parse_mode: 'Markdown'
          )
          return
        end
        
        # Показываем краткий обзор завершенных категорий
        completed_categories = progress[:completed_categories].map do |idx|
          "#{REFLECTION_CATEGORIES[idx][:emoji]} #{REFLECTION_CATEGORIES[idx][:name]}"
        end
        
        send_message(
          text: "📊 *Обзор завершенных категорий:*\n\n#{completed_categories.join("\n")}",
          parse_mode: 'Markdown'
        )
      end
      
      def show_reflection_challenges
        send_message(
          text: "🤔 *С какими трудностями столкнулись в процессе рефлексии 3 недель?*",
          parse_mode: 'Markdown',
          reply_markup: day_21_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge_options = [
          "🧠 Сложно вспомнить все 3 недели",
          "😔 Чувствую, что мог достичь большего",
          "🤔 Не уверен(а), как оценить свой прогресс",
          "😰 Беспокоюсь о поддержании изменений",
          "🌀 Слишком много информации для анализа"
        ]
        
        if challenge_index.to_i.between?(0, 4)
          solutions = [
            "Начните с последних дней и двигайтесь назад. Вспомните 3-4 самых ярких момента — этого достаточно для осмысления.",
            "Прогресс — это не гонка. Каждый шаг имеет ценность. Отметьте даже маленькие изменения — они формируют фундамент.",
            "Сравните себя сегодня с собой 3 недели назад. Что изменилось в ваших реакциях, мыслях, повседневных выборах?",
            "Изменения требуют времени. Создайте простую систему поддержки: 1 техника в день, 1 отзыв в неделю.",
            "Фокус на качестве, а не количестве. Выберите 2-3 самые ценные техники и углубите их, вместо поверхностного охвата всех."
          ]
          
          send_message(
            text: "🌀 **#{challenge_options[challenge_index.to_i]}**\n\n💡 *Решение:* #{solutions[challenge_index.to_i]}",
            parse_mode: 'Markdown'
          )
        end
        
        send_message(
          text: "🌟 Отлично! Вы завершили глубинную рефлексию 3 недель!\n\nХотите завершить День 21 и получить персонализированные рекомендации?",
          reply_markup: day_21_final_completion_markup
        )
      end
      
      def complete_exercise
  progress = get_reflection_progress
  completed_count = progress[:completed_categories].size
  
  log_info("Completing exercise. Progress: #{progress.inspect}")
  log_info("Completed categories: #{completed_count}")
  log_info("Reflections: #{progress[:reflections].inspect}")
  
  # Подсчитываем общую длину всех рефлексий
  total_length = progress[:reflections].values.sum { |r| r[:length].to_i }
  
  log_info("Total reflection length: #{total_length}")
  
  # Подсчитываем общую длину всех рефлексий
  total_length = progress[:reflections].values.sum { |r| r[:length].to_i }
  
  # Отмечаем день как завершенный в программе
  @user.complete_day_program(DAY_NUMBER)
  @user.complete_self_help_day(DAY_NUMBER)
  
  # Устанавливаем состояние завершения
  @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  
  completion_message = <<~MARKDOWN
    🎊 *День 21 и первые 3 недели программы завершены!* 🎉

    **Ваши достижения за 21 день:**

    📊 **Итоги рефлексии:**
    • ✅ Завершено категорий: #{completed_count}/#{REFLECTION_CATEGORIES.size}
    • 📝 Общий объем: #{total_length} символов глубинного анализа
    • 🧠 Приобретение: Навык системной интеграции опыта
    
    🏆 **Прогресс за 3 недели:**
    • ✅ Освоено 21+ различных техник самопомощи
    • 📈 Развиты навыки осознанности, эмоционального интеллекта, самосострадания и преодоления страхов
    • 💫 Создана прочная основа для формирования устойчивых привычек
    • 🌱 Прошли 75% программы (21 из 28 дней)

    #{MOTIVATIONAL_QUOTES.sample}
  MARKDOWN
  
  send_message(text: completion_message, parse_mode: 'Markdown')
  
  # Сохраняем финальную рефлексию
  log_info("Calling save_final_reflection_entry from complete_exercise")
  save_final_reflection_entry
  
  # Показываем меню дня 21
  show_three_weeks_menu
  
  # Предлагаем следующий день с ограничениями
  sleep(2)
  propose_next_day_with_restriction
end
      
      def show_three_weeks_menu
        message = <<~MARKDOWN
          📚 *Меню рефлексии 3 недель* 📚

          **Что вы можете сделать сейчас:**

          📊 **Анализ прогресса:** Посмотреть детальную статистику вашей практики за 21 день
          💡 **Персональные рекомендации:** Получить индивидуальные советы на основе ваших ответов
          📖 **Полная рефлексия:** Перечитать ваши итоги 3 недель
          🎯 **Обзор техник:** Повторить самые эффективные инструменты
          🗺️ **План интеграции:** Создать персональный план внедрения в жизнь
          ➡️ **Продолжение программы:** Перейти к финальной неделе

          **Совет:** Запланируйте дату следующей глубокой рефлексии (через 1-2 месяца).
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Выберите действие:",
          reply_markup: day_21_menu_markup
        )
      end
      
      # ===== МЕТОДЫ ДЛЯ МЕНЮ =====
      
      def show_full_reflection
  progress = get_reflection_progress
  
  log_info("Showing full reflection. Progress keys: #{progress.keys}")
  log_info("Reflections count: #{progress[:reflections]&.size}")
  log_info("Reflections data: #{progress[:reflections].inspect}")
  
  if progress[:reflections].empty?
    send_message(text: "📭 *У вас пока нет сохраненных рефлексий.*\n\nПожалуйста, сначала заполните рефлексию через упражнение дня 21.")
    return
  end
  
  # Формируем полную рефлексию
  reflection_text = "📖 *Полная рефлексия 21 дня* 📅 #{Date.current.strftime('%d.%m.%Y')}\n\n"
  
  REFLECTION_CATEGORIES.each do |category|
    # Ищем рефлексию по ID категории
    reflection_key = category[:id].to_s
    reflection = progress[:reflections][reflection_key]
    
    log_info("Processing category #{category[:id]}: key=#{reflection_key}, found=#{!!reflection}")
    
    reflection_text += "#{category[:emoji]} *#{category[:name]}:*\n"
    
    if reflection && reflection.is_a?(Hash) && reflection[:text].present?
      log_info("Category #{category[:id]} has text: #{reflection[:text].truncate(50)}")
      reflection_text += "#{reflection[:text]}\n\n"
    elsif reflection && reflection.is_a?(Hash) && reflection['text'].present?
      # Проверяем также строковые ключи
      log_info("Category #{category[:id]} has text (string key): #{reflection['text'].truncate(50)}")
      reflection_text += "#{reflection['text']}\n\n"
    else
      log_info("Category #{category[:id]} is empty or invalid: #{reflection.inspect}")
      reflection_text += "Не заполнено\n\n"
    end
  end
  
  # Добавляем статистику
  reflection_text += "📊 *Статистика рефлексии:*\n"
  reflection_text += "• Категорий завершено: #{progress[:completed_categories].size}/#{REFLECTION_CATEGORIES.size}\n"
  
  # Считаем общий объем
  total_length = 0
  progress[:reflections].each do |key, reflection|
    if reflection.is_a?(Hash)
      total_length += reflection[:length].to_i if reflection[:length]
      total_length += reflection['length'].to_i if reflection['length']
    end
  end
  
  reflection_text += "• Общий объем: #{total_length} символов\n"
  reflection_text += "• Время начала: #{progress[:start_time].strftime('%H:%M')}\n"
  reflection_text += "• Пройдено дней программы: 21/28 (75%)\n\n"
  reflection_text += "💡 *Совет:* Сохраните этот текст. Возвращайтесь к нему для отслеживания прогресса."
  
  log_info("Reflection text length: #{reflection_text.length}")
  log_info("Final reflection text preview: #{reflection_text.truncate(200)}")
  
  # Разбиваем длинное сообщение на части
  send_long_message(reflection_text, parse_mode: 'Markdown')
end
      
      def show_personalized_recommendations
  progress = get_reflection_progress
  recommendations = []
  
  # Анализируем ответы для персонализированных рекомендаций
  progress[:reflections].each do |category_id, reflection|
    next unless reflection && reflection[:text]  # ЗАЩИТА ОТ NIL!
    
    text = reflection[:text].to_s.downcase  # ЯВНО ПРЕОБРАЗУЕМ В СТРОКУ
    
    case category_id.to_i
    when 0 # Основные трансформации
      if text.include?('тревож') || text.include?('стресс')
        recommendations << "🌊 **Углубите работу с тревогой:** Добавьте ежедневную 5-минутную практику '5-4-3-2-1' для заземления"
      end
    when 1 # Наиболее ценные техники
      if text.include?('дыхан')
        recommendations << "🌬️ **Развивайте дыхательную практику:** Попробуйте разные ритмы дыхания (квадратное, диафрагмальное, 4-7-8)"
      end
      if text.include?('медитац')
        recommendations << "🧘 **Расширьте медитативную практику:** Постепенно увеличивайте время с 5 до 10-15 минут"
      end
    when 2 # Ключевые инсайты
      if text.include?('самосострадан') || text.include?('доброт')
        recommendations << "💝 **Углубите самосострадание:** Создайте ритуал доброты к себе перед сном"
      end
    when 3 # Преодоленные барьеры
      if text.include?('страх') || text.include?('преодолен')
        recommendations << "🦸 **Продолжайте работу со страхами:** Запланируйте по одному маленькому 'страшному' делу в неделю"
      end
    when 4 # План интеграции
      # Даем рекомендации по планированию
      recommendations << "📅 **Систематизируйте практику:** Создайте еженедельное расписание с 3-4 ключевыми техниками"
    end
  end
  
  # Дефолтные рекомендации, если не найдены персонализированные
  if recommendations.empty?
    recommendations = [
      "📅 **Создайте утренний ритуал:** 10 минут утром для настройки дня (дыхание + благодарность + 1 техника)",
      "📝 **Ведите дневник прогресса:** Еженедельные заметки о применении техник и их эффекте",
      "🎯 **Сфокусируйтесь на 2-3 техниках:** Глубокое освоение лучше поверхностного знания многих",
      "🤝 **Найдите поддержку:** Расскажите кому-то о своем прогрессе или найдите единомышленников",
      "🔄 **Создайте систему напоминаний:** Настройте напоминания для ключевых практик"
    ]
  end
  
  message = "💡 *Персонализированные рекомендации на основе вашей рефлексии:*\n\n"
  message += recommendations.uniq.sample(4).map.with_index(1) { |rec, i| "#{i}. #{rec}" }.join("\n\n")
  message += "\n\n**Действие:** Выберите 1-2 рекомендации для внедрения на следующей неделе."
  
  send_message(text: message, parse_mode: 'Markdown')
end
      
      def show_progress_stats
        stats = calculate_three_weeks_stats
        
        message = <<~MARKDOWN
          📈 *Ваша статистика за 21 день* 📈

          **Общий прогресс:**
          ✅ **Дней выполнено:** #{stats[:days_completed]} из 21
          🧠 **Техник попробовано:** ~#{stats[:techniques_tried]} различных практик
          📝 **Записей рефлексии:** #{stats[:reflection_entries]}
          🧘 **Медитаций:** #{stats[:meditation_sessions]} сессий
          🌟 **Приятных активностей:** #{stats[:pleasure_activities]}
          💝 **Актов самосострадания:** #{stats[:self_compassion_practices]}
          🤝 **Восстановленных связей:** #{stats[:reconnections]}

          **Научный контекст:**
          • 🧠 **Нейропластичность:** Каждая практика создавала новые нейронные связи
          • 🔄 **Привычка:** 21 день — достаточный срок для формирования основы привычки
          • 📊 **Консолидация:** Сейчас происходит интеграция опыта в долговременную память
          • 💪 **Устойчивость:** Вы создали прочную основу для долгосрочных изменений

          **🎯 Ваш следующий рубеж:** 28 дней — полный цикл формирования привычки!
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def show_techniques_review
        techniques = [
          "🌬️ **Дыхание 4-7-8:** Для мгновенного успокоения нервной системы",
          "🙏 **Практика благодарности:** Для смещения фокуса на позитивное",
          "💭 **Когнитивная переоценка:** Для трансформации негативных мыслей",
          "🌍 **Техника заземления 5-4-3-2-1:** Для возврата в настоящее",
          "💝 **Самосострадание:** Для доброты к себе в трудные моменты",
          "🤝 **Восстановление социальных связей:** Для поддержки сети поддержки",
          "🎯 **Маленькие шаги:** Для преодоления страхов через микро-действия",
          "🧘 **Осознанная медитация:** Для развития присутствия и ясности"
        ]
        
        message = "🔄 *Обзор самых эффективных техник за 3 недели:*\n\n"
        message += techniques.sample(5).join("\n\n")
        message += "\n\n**Задание:** Выберите 2-3 техники для углубления на следующей неделе."
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
  case callback_data
  when 'start_day_21_content', 'start_day_21_exercise'
    deliver_exercise
    
  when /^day_21_skip_(\d+)$/
    skip_category($1.to_i)
    
  when /^day_21_challenge_(\d+)$/
    handle_challenge_selection($1)
    
  when 'day_21_no_challenges'
    send_message(text: "🌟 Отлично! Рефлексия прошла продуктивно!")
    send_message(
      text: "Завершаем День 21 и переходим к рекомендациям?",
      reply_markup: day_21_final_completion_markup
    )
    
  when 'day_21_show_full_reflection'
    show_full_reflection
    
  when 'day_21_show_recommendations'
    show_personalized_recommendations
    
  when 'day_21_complete_exercise'
    complete_exercise
    
  when 'day_21_show_stats'
    show_progress_stats
    
  when 'day_21_review_techniques'
    show_techniques_review
    
  when 'day_21_personal_plan'
    show_personal_plan
    
  when 'day_21_debug_data'  # НОВЫЙ ОБРАБОТЧИК
    debug_reflection_data
    
  when 'back_to_day_21_menu'
    show_three_weeks_menu
    
  else
    log_warn("Unknown button callback: #{callback_data}")
    send_message(text: "Неизвестная команда.")
  end
end
      
      # Обработка текстового ввода
      def handle_text_input(input_text)
        current_state = @user.self_help_state
        
        # Определяем, какая категория рефлексии активна
        if current_state&.start_with?("day_#{DAY_NUMBER}_waiting_reflection_")
          category_index = current_state.split('_').last.to_i
          return handle_reflection_text(input_text, category_index)
        end
        
        false
      end
      
      private
      
      # ===== ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =====
      
      # Методы разметки
      def day_21_content_markup
        {
          inline_keyboard: [
            [
              { text: "📊 Начать рефлексию 3 недель", callback_data: 'start_day_21_content' }
            ],
            [
              { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' }
            ]
          ]
        }.to_json
      end
      
      def day_21_category_options_markup(category_index)
        {
          inline_keyboard: [
            [
              { text: "⏭️ Пропустить эту категорию", callback_data: "day_21_skip_#{category_index}" }
            ]
          ]
        }.to_json
      end
      
      def day_21_challenges_markup
        {
          inline_keyboard: [
            [
              { text: "🧠 Сложно вспомнить все", callback_data: 'day_21_challenge_0' }
            ],
            [
              { text: "😔 Мог достичь большего", callback_data: 'day_21_challenge_1' }
            ],
            [
              { text: "🤔 Не уверен в оценке", callback_data: 'day_21_challenge_2' }
            ],
            [
              { text: "😰 Беспокоюсь о поддержании", callback_data: 'day_21_challenge_3' }
            ],
            [
              { text: "🌀 Слишком много информации", callback_data: 'day_21_challenge_4' }
            ],
            [
              { text: "✅ Никаких трудностей", callback_data: 'day_21_no_challenges' }
            ]
          ]
        }.to_json
      end
      
      def day_21_final_completion_markup
        {
          inline_keyboard: [
            [
              { text: "💡 Получить рекомендации", callback_data: 'day_21_show_recommendations' },
              { text: "📖 Посмотреть рефлексию", callback_data: 'day_21_show_full_reflection' }
            ],
            [
              { text: "🎉 Завершить 3 недели!", callback_data: 'day_21_complete_exercise' }
            ]
          ]
        }.to_json
      end
      
      def day_21_menu_markup
  {
    inline_keyboard: [
      [
        { text: "📊 Моя статистика", callback_data: 'day_21_show_stats' },
        { text: "💡 Рекомендации", callback_data: 'day_21_show_recommendations' }
      ],
      [
        { text: "📖 Полная рефлексия", callback_data: 'day_21_show_full_reflection' },
        { text: "🔄 Обзор техник", callback_data: 'day_21_review_techniques' }
      ],
      [
        { text: "🗺️ Персональный план", callback_data: 'day_21_personal_plan' }
      ],
      [
        { text: "🏠 Главное меню", callback_data: 'back_to_main_menu' },
        { text: "➡️ Следующий день", callback_data: 'start_day_22_from_proposal' }
      ]
    ]
  }.to_json
end
      
      # Методы управления прогрессом рефлексии
      def get_reflection_progress
  log_info("Getting reflection progress from day data")
  
  progress_data = get_day_data('reflection_progress') || {}
  
  log_info("Raw progress data type: #{progress_data.class}")
  log_info("Raw progress data keys: #{progress_data.keys}")
  
  # Нормализуем reflections
  reflections = {}
  raw_reflections = progress_data['reflections'] || progress_data[:reflections] || {}
  
  log_info("Raw reflections type: #{raw_reflections.class}")
  log_info("Raw reflections keys: #{raw_reflections.keys}")
  
  raw_reflections.each do |key, value|
    log_info("Processing reflection #{key}: #{value.class}")
    
    if value.is_a?(Hash)
      # Создаем нормализованный хэш с обоими типами ключей
      normalized = {}
      
      # Копируем все ключи как символьные
      value.each do |k, v|
        normalized[k.to_sym] = v if k
      end
      
      # Также копируем как строковые для обратной совместимости
      value.each do |k, v|
        normalized[k.to_s] = v if k
      end
      
      reflections[key.to_s] = normalized
    else
      reflections[key.to_s] = value
    end
  end
  
  result = {
    current_category_index: progress_data['current_category_index']&.to_i || progress_data[:current_category_index]&.to_i || 0,
    completed_categories: Array(progress_data['completed_categories'] || progress_data[:completed_categories]).map(&:to_i),
    reflections: reflections,
    start_time: begin
      time_str = progress_data['start_time'] || progress_data[:start_time]
      Time.parse(time_str) if time_str
    rescue => e
      log_error("Failed to parse start_time: #{time_str}", e)
      Time.current
    end
  }
  
  log_info("Processed reflection progress:")
  log_info("• Categories: #{result[:completed_categories]}")
  log_info("• Reflections count: #{result[:reflections].size}")
  result[:reflections].each do |key, value|
    log_info("• Reflection #{key}: #{value.inspect}")
  end
  
  result
end
      
      def save_reflection_progress(progress)
  log_info("Saving reflection progress: #{progress.inspect}")
  
  store_day_data('reflection_progress', {
    current_category_index: progress[:current_category_index],
    completed_categories: progress[:completed_categories],
    reflections: progress[:reflections],
    start_time: progress[:start_time].iso8601
  })
  
  # Проверяем, что сохранилось
  saved_progress = get_day_data('reflection_progress')
  log_info("Verified saved progress: #{saved_progress.inspect}")
end
      
      def show_reflection_progress(current_index)
        total = REFLECTION_CATEGORIES.size
        progress_bar = "🟩" * (current_index) + "⬜" * (total - current_index)
        
        send_message(
          text: "📊 *Прогресс рефлексии:* #{progress_bar} (#{current_index + 1}/#{total})",
          parse_mode: 'Markdown'
        )
      end
      
      def category_prompt_with_progress(category, current_index)
        <<~MARKDOWN
          #{category[:emoji]} *Категория #{current_index + 1}/#{REFLECTION_CATEGORIES.size}: #{category[:name]}*
          
          #{category[:prompt]}
          
          *Инструкция:* Просто напишите ваш ответ и отправьте его как обычное сообщение.
          *Бот автоматически сохранит его и перейдет к следующей категории.*
          
          💡 *Совет:* Отвечайте максимально честно и подробно — это ваш личный навигатор прогресса.
        MARKDOWN
      end
      
      def category_emoji(category_index)
        REFLECTION_CATEGORIES[category_index][:emoji] rescue "📝"
      end
      
      def completion_summary_message(completed_count)
        total = REFLECTION_CATEGORIES.size
        
        if completed_count == total
          "🎉 *Отлично! Вы завершили все #{total} категории рефлексии 3 недель!*"
        elsif completed_count >= total / 2
          "✅ *Хорошая работа! Вы завершили #{completed_count} из #{total} категорий.*"
        elsif completed_count > 0
          "📝 *Вы начали рефлексию, завершив #{completed_count} категорий.*"
        else
          "⏭️ *Вы пропустили все категории. Рефлексия завершена.*"
        end
      end
      
      def save_three_weeks_reflection_entry
        progress = get_reflection_progress
        return if progress[:reflections].empty?
        
        # Эта промежуточная версия сохраняется в self_help_program_data
        # Финальная версия сохраняется в complete_exercise через save_final_reflection_entry
        log_info("Saved intermediate reflection with #{progress[:completed_categories].size} categories")
      end
      
      def save_final_reflection_entry
  progress = get_reflection_progress
  
  # Логируем, что у нас есть
  log_info("Saving final reflection with progress: #{progress.inspect}")
  
  begin
    # Собираем все рефлексии в структурированный текст
    full_text = ""
    
    REFLECTION_CATEGORIES.each do |category|
      reflection = progress[:reflections][category[:id].to_s]
      
      if reflection && reflection[:text].present?
        full_text += "#{category[:emoji]} *#{category[:name]}:*\n"
        full_text += "#{reflection[:text]}\n\n"
      else
        full_text += "#{category[:emoji]} *#{category[:name]}:*\n"
        full_text += "Не заполнено\n\n"
      end
    end
    
    # Добавляем заголовок и метаданные
    final_text = <<~TEXT
      📖 *Рефлексия 21 дня программы* 📅 #{Date.current.strftime('%d.%m.%Y')}
      ⏰ Время: #{progress[:start_time].strftime('%H:%M')}
      
      #{full_text}
      
      📊 *Статистика рефлексии:*
      • Категорий завершено: #{progress[:completed_categories].size}/#{REFLECTION_CATEGORIES.size}
      • Общий объем: #{progress[:reflections].values.sum { |r| r[:length].to_i }} символов
      • Пройдено дней программы: 21/28 (75%)
      • Продолжительность рефлексии: #{(Time.current - progress[:start_time]).to_i / 60} минут
      
      💡 *Эта рефлексия будет полезным ориентиром для оценки дальнейшего прогресса.*
    TEXT
    
    log_info("Attempting to save reflection entry. Text length: #{final_text.length}")
    
    # Сохраняем в ReflectionEntry
    reflection_entry = ReflectionEntry.new(
      user: @user,
      entry_date: Date.current,
      entry_text: final_text,
      reflection_type: 'three_weeks'
    )
    
    # Пробуем сохранить
    if reflection_entry.save
      log_info("Successfully saved final three weeks reflection with ID: #{reflection_entry.id}")
      
      # Проверяем, что запись действительно сохранена
      saved_entry = ReflectionEntry.find_by(id: reflection_entry.id)
      if saved_entry
        log_info("Verified: Reflection entry saved successfully. ID: #{saved_entry.id}, Date: #{saved_entry.entry_date}")
      else
        log_warn("Reflection entry not found after save!")
      end
    else
      log_error("Failed to save reflection entry. Errors: #{reflection_entry.errors.full_messages}")
    end
    
  rescue => e
    log_error("Failed to save final three weeks reflection", e)
    # Показываем ошибку пользователю
    send_message(
      text: "⚠️ Не удалось сохранить вашу рефлексию. Пожалуйста, сохраните текст вручную:",
      parse_mode: 'Markdown'
    )
    send_message(text: full_text || "Рефлексия не заполнена")
  end
end
      
      def three_weeks_statistics_message
        completed_days = @user.completed_days || []
        three_weeks_days = completed_days.select { |day| day <= 21 }
        
        <<~MARKDOWN
          📊 *Ваша статистика за 3 недели:*
          
          • ✅ Завершено дней: #{three_weeks_days.size}/21
          • 📈 Прогресс 3 недель: #{(three_weeks_days.size.to_f / 21 * 100).round}%
          • 🏆 Серия дней: #{@user.current_streak} дней подряд
          • 💫 Общий прогресс: #{@user.progress_percentage}%
          • 🎯 Пройдено программы: 75%
          
          *Напоминание:* Вы прошли 75% пути — это впечатляющее достижение!
        MARKDOWN
      end
      
      def calculate_three_weeks_stats
        {
          days_completed: (@user.completed_days || []).count { |day| day <= 21 },
          techniques_tried: 21, # Примерное количество за 3 недели
          reflection_entries: @user.reflection_entries.where("entry_date >= ?", 3.weeks.ago).count,
          meditation_sessions: calculate_meditation_sessions,
          pleasure_activities: calculate_pleasure_activities,
          self_compassion_practices: calculate_self_compassion_practices,
          reconnections: calculate_reconnections
        }
      end
      
      def calculate_meditation_sessions
        # Здесь должна быть логика подсчета медитаций из вашей модели
        # Временная реализация
        rand(5..15)
      end
      
      def calculate_pleasure_activities
        # Здесь должна быть логика подсчета приятных активностей
        rand(3..10)
      end
      
      def calculate_self_compassion_practices
        # Здесь должна быть логика подсчета практик самосострадания
        rand(2..8)
      end
      
      def calculate_reconnections
        # Здесь должна быть логика подсчета восстановленных связей
        rand(1..5)
      end
      
      def show_personal_plan
        progress = get_reflection_progress
        integration_text = progress[:reflections]["4"]&.dig(:text) || "Используйте ваши ответы из рефлексии для создания плана"
        
        message = <<~MARKDOWN
          🗺️ *Ваш персональный план интеграции на следующие 30 дней* 🗺️

          **Основа плана:** 
          #{integration_text.truncate(300)}

          **Рекомендуемая структура:**

          📅 **Ежедневные практики (10-15 минут):**
          1. Утренняя настройка (дыхание + намерение дня)
          2. 1 ключевая техника из вашего списка
          3. Вечерняя благодарность или рефлексия

          🗓️ **Еженедельные ритуалы (30-45 минут):**
          1. Воскресный обзор недели
          2. Планирование одной "маленькой победы" на неделю
          3. Практика восстановления одной социальной связи

          📊 **Ежемесячные точки отсчета (1-2 часа):**
          1. Полная рефлексия как сегодня
          2. Корректировка плана по необходимости
          3. Награждение себя за прогресс

          **Система поддержки:**
          • 📱 Настройте напоминания для ключевых практик
          • 📝 Ведите простой дневник прогресса (1 предложение в день)
          • 🤝 Найдите единомышленника для взаимной поддержки
          • 🎯 Определите "якоря" — действия, которые возвращают к практике

          **Совет:** Создайте визуальное напоминание о плане (стикер на мониторе, заставка на телефоне).
        MARKDOWN
        
        send_message(text: message, parse_mode: 'Markdown')
      end
      
      def propose_next_day_with_restriction
        next_day = 22
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День 22**
            
            ✅ *Доступен сейчас!*
            
            **Что вас ждет в финальной неделе программы:**
            • 🧠 Интеграция всех освоенных техник в единую систему
            • 💪 Работа с глубинными убеждениями и установками
            • 🔄 Создание персональной системы самопомощи
            • 🌟 Подготовка к самостоятельному продолжению практики
            
            **Это финальная неделя программы** — время закрепить все достижения и создать устойчивую систему.
            
            Вы можете начать финальную неделю прямо сейчас.
          MARKDOWN
          
          button_text = "🚀 Начать День 22"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = <<~MARKDOWN
            🎯 **Следующий шаг: День 22 (Финальная неделя)**
            
            ⏱️ *Ограничение:* #{error_message}
            
            **Пока ждете, можете:**
            • 📖 Перечитать свою рефлексию 3 недель
            • 🧠 Практиковать самые эффективные для вас техники
            • 📊 Проанализировать статистику прогресса
            • 🎯 Начать создавать персональный план интеграции
            • 🌟 Отпраздновать достижение 75% пути!
            
            *Финальная неделя программы будет автоматически доступна, когда пройдет достаточно времени.*
          MARKDOWN
          
          button_text = "⏱️ Проверить доступность Дня 22"
          callback_data = "start_day_#{next_day}_from_proposal"
        end
        
        send_message(text: message, parse_mode: 'Markdown')
        
        send_message(
          text: "Нажмите кнопку:",
          reply_markup: {
            inline_keyboard: [
              [
                { 
                  text: button_text, 
                  callback_data: callback_data
                }
              ]
            ]
          }.to_json
        )
      end
      
      # Метод для отправки длинных сообщений с разбивкой
      def send_long_message(text, options = {})
        max_length = 4096 # Максимальная длина сообщения в Telegram
        
        if text.length <= max_length
          send_message(text: text, **options)
        else
          # Разбиваем текст на части
          parts = []
          current_part = ""
          
          text.split("\n").each do |line|
            if (current_part + line + "\n").length > max_length
              parts << current_part
              current_part = line + "\n"
            else
              current_part += line + "\n"
            end
          end
          
          parts << current_part unless current_part.empty?
          
          # Отправляем части с небольшой задержкой
          parts.each_with_index do |part, index|
            send_message(text: part, **options)
            sleep(0.5) if index < parts.size - 1
          end
        end
      end
      
      def log_info(message)
        Rails.logger.info "[Day21Service] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[Day21Service] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.first(5).join("\n") if error&.backtrace
      end
      
      def log_warn(message)
        Rails.logger.warn "[Day21Service] #{message} - User: #{@user.telegram_id}"
      end
    end
  end
end