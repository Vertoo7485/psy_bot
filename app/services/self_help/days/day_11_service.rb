# app/services/self_help/days/day_11_service.rb
module SelfHelp
  module Days
    class Day11Service < DayBaseService
      include TelegramMarkupHelper
      
      # Константы
      DAY_NUMBER = 11
      
      # Шаги дня 11
      DAY_STEPS = {
        'intro' => {
          title: "🌍 *День 11: Техника заземления 5-4-3-2-1* 🧘",
          instruction: "**Добро пожаловать в мир осознанного присутствия!** 🌟\n\nСегодня вы освоите одну из самых эффективных техник экстренной самопомощи — заземление через 5 чувств. Это ваш якорь в моменты тревоги, паники или диссоциации.\n\n📊 **Научные факты о технике заземления:**\n• 🧠 Активирует соматосенсорную кору на 40-50% (обработка телесных ощущений)\n• 😌 Снижает активность амигдалы (центр страха) на 30-40%\n• 🔄 Прерывает цикл тревожных мыслей за 60-90 секунд\n• 🎯 Эффективность при панических атаках: 70-80%\n• 📍 Увеличивает осознанность в настоящем моменте на 50-60%\n• 💡 Основана на принципах когнитивно-поведенческой терапии (КПТ) и mindfulness\n\n🎯 **Что вы получите от сегодняшней практики:**\n1. 🚨 Инструмент экстренной самопомощи при тревоге\n2. 🧠 Навык быстрого возвращения в настоящее\n3. 👁️ Улучшенную сенсорную осознанность\n4. 😌 Снижение интенсивности панических ощущений\n5. 🔄 Умение прерывать диссоциативные состояния\n\n**Мозговой механизм техники:**\n• 👁️ Зрение → активация затылочной доли\n• ✋ Осязание → активация теменной доли\n• 👂 Слух → активация височной доли\n• 👃 Обоняние → активация обонятельной коры\n• 👅 Вкус → активация островковой доли\n*Итог: весь мозг включается в настоящее!*"
        },
        'exercise_explanation' => {
          title: "🔬 *Техника 5-4-3-2-1: Научный алгоритм* 📋",
          instruction: "**Как работает техника 5-4-3-2-1?**\n\nЭто структурированная последовательность активации всех 5 чувств, которая:\n1. 👁️ **5 вещей, которые видите** → зрительная система\n2. ✋ **4 вещи, которые чувствуете** → тактильная система\n3. 👂 **3 вещи, которые слышите** → слуховая система\n4. 👃 **2 вещи, которые нюхаете** → обонятельная система\n5. 👅 **1 вещь, которую пробуете** → вкусовая система\n\n**Научный механизм:**\n• 🧠 Переключает фокус с внутренних переживаний на внешнюю реальность\n• 🔄 Прерывает петлю тревожных мыслей (руминацию)\n• 📍 Активирует префронтальную кору (контроль)\n• 😌 Снижает выброс кортизола (гормон стресса) на 25-35%\n• 💡 Увеличивает уровень ГАМК (успокаивающий нейромедиатор)\n\n**Эффективность:** 60-90 секунд для заметного эффекта.\n*Практикуйте заранее, чтобы техника работала лучше в экстренной ситуации.*"
        },
        'grounding_benefits' => {
          title: "🌟 *Польза регулярной практики заземления* 📈",
          instruction: "**Что дает регулярное использование техники 5-4-3-2-1?**\n\n📊 **Доказанные эффекты (исследования Harvard, Yale):**\n• 40-50% снижение интенсивности панических атак\n• 30-40% уменьшение общего уровня тревоги\n• 25-35% улучшение способности к саморегуляции\n• 20-30% повышение осознанности в повседневной жизни\n• 35-45% снижение диссоциативных эпизодов\n• 50-60% уменьшение времени восстановления после стресса\n\n**Нейробиологические изменения:**\n🧠 Укрепляет связь между префронтальной корой и лимбической системой\n🔄 Создает новые нейронные пути для быстрого успокоения\n💡 Увеличивает объем серого вещества в зонах саморегуляции\n📈 Повыжает активность островковой доли (телесное осознание)\n\n**Рекомендация:** Практиковать 1-2 раза в день, даже когда спокоены.\nЭто укрепляет нейронные пути, делая технику более эффективной в кризис."
        },
        'completion' => {
          title: "🎊 *Техника освоена!* 🎯",
          instruction: "**Отличная работа! Вы только что освоили мощную технику экстренной самопомощи!** 🌟\n\n**Что вы сделали:**\n1. 👁️ Активировали зрительную систему (5 вещей)\n2. ✋ Активировали тактильную систему (4 вещи)\n3. 👂 Активировали слуховую систему (3 звука)\n4. 👃 Активировали обонятельную систему (2 запаха)\n5. 👅 Активировали вкусовую систему (1 вкус)\n\n**Поздравляем!** Вы освоили технику, которая:\n• 🧠 Используется в когнитивно-поведенческой терапии (КПТ)\n• 📊 Подтверждена исследованиями в нейропсихологии\n• 😌 Помогает миллионам людей по всему миру\n• 🚨 Является стандартом первой помощи при панике\n\n**Следующие шаги:**\n• 🔄 Практикуйте технику в разных ситуациях\n• 🧠 Используйте при первых признаках тревоги\n• 📝 Ведите дневник эффективности\n• 🤝 Делитесь техникой с близкими"
        }
      }.freeze
      
      # Шаги заземления (техника 5-4-3-2-1)
      GROUNDING_STEPS = {
        'seen' => {
          title: "👁️ *Шаг 1: 5 вещей, которые вы видите* 🎨",
          instruction: "**Оглядитесь вокруг и назовите 5 вещей, которые вы видите.**\n\n**Примеры:**\n• Предметы в комнате (стол, стул, окно)\n• Цвета (синяя чашка, зеленая книга)\n• Формы и текстуры\n• Детали обстановки\n• Любые видимые объекты\n\n**Научный факт:** Зрительная информация обрабатывается за 13 миллисекунд — самый быстрый способ «заземлиться».\n\n**Напишите 5 вещей через запятую:**",
          min_count: 5,
          emoji: "👁️",
          sense: "зрение"
        },
        'touched' => {
          title: "✋ *Шаг 2: 4 вещи, которые вы можете потрогать* 👐",
          instruction: "**Найдите 4 вещи, которые можете потрогать прямо сейчас.**\n\n**Обратите внимание на:**\n• Текстуру (гладкая, шершавая, мягкая, твердая)\n• Температуру (теплая, холодная, комнатная)\n• Форму и размер\n• Давление (легкое, сильное)\n\n**Примеры ощущений:**\n• Гладкая поверхность стола\n• Теплая ткань одежды\n• Прохладный экран телефона\n• Шершавая стена\n\n**Научный факт:** Тактильные ощущения активируют соматосенсорную кору, которая напрямую связана с эмоциональной регуляцией.\n\n**Опишите 4 вещи и ощущения от них:**",
          min_count: 4,
          emoji: "✋",
          sense: "осязание"
        },
        'heard' => {
          title: "👂 *Шаг 3: 3 вещи, которые вы слышите* 🔊",
          instruction: "**Прислушайтесь и назовите 3 звука, которые слышите.**\n\n**Это могут быть:**\n• Звуки окружающей среды (улица, дом)\n• Ваше собственное дыхание или сердцебиение\n• Отдаленные шумы\n• Тишина (это тоже звук!)\n\n**Примеры:**\n• Шум компьютера\n• Пение птиц за окном\n• Собственное дыхание\n• Тиканье часов\n\n**Научный факт:** Слуховая система помогает «заякорить» в настоящем, так как звуки существуют только «здесь и сейчас».\n\n**Перечислите 3 звука:**",
          min_count: 3,
          emoji: "👂",
          sense: "слух"
        },
        'smelled' => {
          title: "👃 *Шаг 4: 2 вещи, запах которых вы чувствуете* 🌸",
          instruction: "**Постарайтесь почувствовать 2 разных запаха.**\n\n**Если рядом нет явных запахов:**\n• Почувствуйте запах собственной кожи\n• Запах одежды или ткани\n• Запах воздуха в комнате\n• Запах своих рук\n\n**Примеры:**\n• Запах свежего воздуха\n• Аромат кофе или чая\n• Запах книги или бумаги\n• Свой собственный естественный запах\n\n**Научный факт:** Обоняние напрямую связано с лимбической системой (эмоции) и памятью — мощный инструмент заземления.\n\n**Что вы чувствуете? Назовите 2 запаха:**",
          min_count: 2,
          emoji: "👃",
          sense: "обоняние"
        },
        'tasted' => {
          title: "👅 *Шаг 5: 1 вещь, которую вы можете попробовать на вкус* 🍎",
          instruction: "**Найдите 1 вещь, которую можете попробовать на вкус.**\n\n**Это может быть:**\n• Еда или напиток (если есть рядом)\n• Вкус во рту (остаточный вкус)\n• Собственная слюна\n• Мятная конфета или жвачка\n\n**Если нет пищи рядом:**\n• Обратите внимание на вкус во рту\n• Сделайте глоток воды\n• Подумайте о вкусе любимой еды\n\n**Научный факт:** Вкус активирует островковую долю мозга, которая отвечает за телесное осознание и саморегуляцию.\n\n**Опишите вкус:**",
          min_count: 1,
          emoji: "👅",
          sense: "вкус"
        }
      }.freeze
      
      # Типичные трудности в практике
      GROUNDING_CHALLENGES = [
        {
          challenge: "Не могу найти нужное количество предметов",
          emoji: "🔍",
          solution: "Это нормально! Используйте повторения или включите части одного предмета (например, разные части стула: спинка, сиденье, ножки)."
        },
        {
          challenge: "Мысли всё равно отвлекают",
          emoji: "💭",
          solution: "Каждое возвращение к упражнению — это победа! Просто мягко возвращайтесь к следующему пункту. Каждое возвращение укрепляет навык."
        },
        {
          challenge: "Чувствую себя глупо, делая это",
          emoji: "😳",
          solution: "Помните: эффективность важнее, чем то, как это выглядит со стороны. Эта техника научно доказана и используется терапевтами по всему миру."
        },
        {
          challenge: "Не чувствую эффекта сразу",
          emoji: "⏳",
          solution: "Эффект накапливается. Первые разы могут быть сложными. Как в спортзале — первые тренировки тяжелы, но мышцы крепнут с каждой практикой."
        }
      ].freeze
      
      # ===== ПУБЛИЧНЫЕ МЕТОДЫ =====
      
      def deliver_intro
        # Шаг 1: Введение в день 11
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        
        # Статистика для мотивации
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_intro")
        store_day_data('current_step', 'intro')
        
        send_message(
          text: "Готовы освоить технику экстренного заземления?",
          reply_markup: day_11_content_markup
        )
      end
      
      def deliver_exercise
        @user.set_self_help_step("day_#{DAY_NUMBER}_exercise_in_progress")
        store_day_data('current_step', 'exercise_explanation')
        
        send_message(text: DAY_STEPS['exercise_explanation'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['exercise_explanation'][:instruction], parse_mode: 'Markdown')
        
        send_message(
          text: "🌍 *Техника 5-4-3-2-1: Практическое руководство* 📋",
          parse_mode: 'Markdown'
        )
        
        send_message(
          text: "🎯 *Перед началом:*\n\n• Найдите относительно спокойное место\n• Сядьте или встаньте удобно\n• Дышите естественно\n• Будьте добры к себе — это навык, который развивается\n\nГотовы начать?",
          parse_mode: 'Markdown',
          reply_markup: day_11_grounding_start_markup
        )
      end
      
      def start_grounding_exercise
        # Очищаем предыдущие данные
        clear_grounding_data
        
        # Начинаем с первого шага
        store_day_data('grounding_started_at', Time.current)
        start_grounding_step('seen')
      end
      
      def start_grounding_step(step_type)
        store_day_data('current_grounding_step', step_type)
        @user.set_self_help_step("day_#{DAY_NUMBER}_waiting_for_#{step_type}")
        
        step = GROUNDING_STEPS[step_type]
        return unless step
        
        send_message(text: step[:title], parse_mode: 'Markdown')
        send_message(text: step[:instruction], parse_mode: 'Markdown')
        
        # Показываем подсказку с эмодзи
        send_message(
          text: "#{step[:emoji]} *#{step[:sense].upcase}: Напишите #{step[:min_count]} #{step[:min_count] == 1 ? 'вещь' : 'вещи(ей)'}*",
          parse_mode: 'Markdown',
          reply_markup: day_11_input_markup
        )
      end
      
      def handle_grounding_input(input_text)
        current_step = get_day_data('current_grounding_step')
        step_config = GROUNDING_STEPS[current_step]
        
        return false unless step_config
        
        # Проверяем минимальное количество элементов
        if input_text.present?
          # Принимаем разные разделители: запятая, точка, точка с запятой, пробел, перенос строки
          items = input_text.split(/[,;.\s\n]+/)
                           .map(&:strip)
                           .reject(&:blank?)
          
          # Если после split нет элементов (пользователь ввел одно слово без разделителей)
          if items.empty? && input_text.strip.present?
            items = [input_text.strip]
          end
          
          if items.length < step_config[:min_count]
            send_message(
              text: "❌ *Недостаточно элементов!*\n\nПожалуйста, назовите минимум #{step_config[:min_count]} #{step_config[:min_count] == 1 ? 'вещь' : 'вещи(ей)'}.\n\nВы можете перечислять:\n• Через запятую: стол, стул, окно, книга, чашка\n• Через пробел: стол стул окно книга чашка\n• Через точку: стол. стул. окно. книга. чашка\n• Через точку с запятой: стол; стул; окно; книга; чашка\n\nПопробуйте еще раз:",
              parse_mode: 'Markdown'
            )
            return false
          end
        else
          send_message(text: "⚠️ Пожалуйста, введите ответ.")
          return false
        end
        
        # Сохраняем данные
        store_day_data("#{current_step}_items", items)
        store_day_data("#{current_step}_completed", true)
        
        # Подтверждаем сохранение
        send_message(
          text: "✅ #{step_config[:emoji]} *Шаг завершен!* Сохранено #{items.length} #{step_config[:sense]}.",
          parse_mode: 'Markdown'
        )
        
        # Переходим к следующему шагу
        next_step = get_next_grounding_step(current_step)
        
        if next_step
          sleep(1) # Небольшая пауза между шагами
          start_grounding_step(next_step)
        else
          # Все шаги выполнены
          complete_grounding_practice
        end
        
        true
      end
      
      def complete_grounding_practice
        store_day_data('grounding_completed', true)
        store_day_data('completion_time', Time.current)
        
        # Сохраняем в модель GroundingExerciseEntry
        save_grounding_entry
        
        @user.set_self_help_step("day_#{DAY_NUMBER}_grounding_completed")
        
        # Показываем пользу практики
        show_grounding_benefits
      end
      
      def show_grounding_benefits
        store_day_data('current_step', 'grounding_benefits')
        
        send_message(text: DAY_STEPS['grounding_benefits'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['grounding_benefits'][:instruction], parse_mode: 'Markdown')
        
        # Показываем краткий обзор практики
        show_grounding_summary
        
        sleep(1)
        
        send_message(
          text: "🌟 Отличная работа! Вы завершили практику заземления.\n\nС какими трудностями столкнулись?",
          parse_mode: 'Markdown',
          reply_markup: day_11_challenges_markup
        )
      end
      
      def handle_challenge_selection(challenge_index)
        challenge = GROUNDING_CHALLENGES[challenge_index.to_i]
        
        if challenge
          send_message(
            text: "#{challenge[:emoji]} **#{challenge[:challenge]}**\n\n#{challenge[:solution]}",
            parse_mode: 'Markdown'
          )
        end
        
        # МЕНЯЕМ СОСТОЯНИЕ после выбора трудности
        @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
        
        send_message(
          text: "🎯 Техника заземления освоена!\n\nХотите завершить День 11?",
          reply_markup: day_11_final_completion_markup
        )
      end
      
      def show_grounding_summary
        seen_items = get_day_data('seen_items') || []
        heard_items = get_day_data('heard_items') || []
        
        summary = "📊 *Краткий обзор вашей практики:*\n\n👁️ **5 вещей, которые вы видели:** #{Array(seen_items).length > 0 ? Array(seen_items).first(3).join(', ') + (Array(seen_items).length > 3 ? '...' : '') : 'не указаны'}\n\n👂 **3 звука, которые вы слышали:** #{Array(heard_items).length > 0 ? Array(heard_items).join(', ') : 'не указаны'}\n\n✅ **Все 5 чувств активированы!**\n\n📅 **Сохранено в вашу коллекцию практик заземления**"
        
        send_message(text: summary, parse_mode: 'Markdown')
      end
      
      def show_previous_grounding_entries
        begin
          entries = GroundingExerciseEntry.where(user: @user).recent.limit(3)
          
          if entries.empty?
            send_message(
              text: "🌍 *Ваши практики заземления:*\n\nПока нет сохраненных практик.\nПройдите упражнение дня 11, чтобы создать первую запись.",
              parse_mode: 'Markdown',
              reply_markup: day_11_content_markup
            )
            return
          end
          
          total_count = GroundingExerciseEntry.where(user: @user).count
          
          send_message(
            text: "🌍 *Ваши последние практики заземления (всего: #{total_count}):*",
            parse_mode: 'Markdown'
          )
          
          entries.each_with_index do |entry, index|
            entry_date = entry.entry_date.strftime('%d.%m.%Y')
            
            # Форматируем данные для каждого чувства
            seen_text = format_sense_items(entry.seen, 2)
            touched_text = format_sense_items(entry.touched, 2)
            heard_text = format_sense_items(entry.heard, 2)
            smelled_text = format_sense_items(entry.smelled, 2)
            tasted_text = format_sense_items(entry.tasted, 2)
            
            entry_summary = <<~MARKDOWN
              *#{index + 1}. #{entry_date}*
              
              👁️ *Видел(а):* #{seen_text}
              ✋ *Чувствовал(а):* #{touched_text}
              👂 *Слышал(а):* #{heard_text}
              👃 *Нюхал(а):* #{smelled_text}
              👅 *Пробовал(а):* #{tasted_text}
            MARKDOWN
            
            send_message(text: entry_summary, parse_mode: 'Markdown')
          end
          
          # Добавляем опцию для новой практики
          send_message(
            text: "Хотите начать новую практику заземления или вернуться в меню?",
            reply_markup: {
              inline_keyboard: [
                [
                  { text: "🔄 Новая практика", callback_data: "day_11_start_grounding" },
                  { text: "🔙 В меню", callback_data: "continue_day_11_content" }
                ]
              ]
            }
          )
          
        rescue => e
          log_error("Error showing grounding entries", e)
          send_message(
            text: "❌ Произошла ошибка при загрузке ваших практик. Попробуйте позже.",
            parse_mode: 'Markdown'
          )
        end
      end
      
def complete_exercise
  # Проверяем, завершена ли практика заземления
  unless get_day_data('grounding_completed') == true
    send_message(
      text: "⚠️ Сначала завершите практику заземления.\n\nУбедитесь, что вы прошли все 5 шагов техники 5-4-3-2-1.",
      parse_mode: 'Markdown',
      reply_markup: day_11_content_markup
    )
    return
  end
  
  # ИСПРАВЛЕНИЕ: Убрали @user.complete_day_program(DAY_NUMBER) - дублирование!
  # Оставляем только complete_self_help_day, который уже включает complete_day_program
  @user.complete_self_help_day(DAY_NUMBER)
  
  # ИСПРАВЛЕНИЕ: Убрали @user.set_self_help_step("day_#{DAY_NUMBER}_completed")
  # complete_self_help_day уже делает set_self_help_step
  
  completion_message = "🎊 *День 11 завершен!* 🎊\n\n**Ваши достижения сегодня:**\n\n🌍 **Техника заземления 5-4-3-2-1:**\n• 👁️ Активированы 5 чувств последовательно\n• 🧠 Освоен алгоритм экстренной самопомощи\n• 😌 Приобретен навык быстрого возвращения в настоящее\n• 🚨 Создан личный инструмент для работы с тревогой\n• 📊 Научно обоснованная техника\n\n📊 **Научный факт:**\nРегулярная практика техники 5-4-3-2-1 снижает интенсивность панических атак на 40-50% и уменьшает общий уровень тревоги на 30-40% за 4-6 недель.\n\n🎯 **Что дальше:**\nЗавтра - День 12: Медитация на самосострадание\n\n⏰ **Следующий день будет доступен через 12 часов**\n\nВаш прогресс: #{@user.progress_percentage}%"
  
  send_message(text: completion_message, parse_mode: 'Markdown')
  
  # Предлагаем следующий день
  propose_next_day_with_restriction
end
      
      # ===== ОБРАБОТКА КНОПОК =====
      
      def handle_button(callback_data)
        case callback_data
        when 'start_day_11_content', 'start_day_11_from_proposal'
          deliver_exercise
          
        when 'continue_day_11_content'
          current_step = get_day_data('current_step')
          handle_resume_from_step(current_step || 'intro')
          
        when 'day_11_start_grounding', 'start_grounding_exercise'
          start_grounding_exercise
          
        when 'day_11_skip_step'
          # Пропуск текущего шага (для крайних случаев)
          current_step = get_day_data('current_grounding_step')
          if current_step
            next_step = get_next_grounding_step(current_step)
            if next_step
              send_message(text: "⚠️ Шаг пропущен. Переходим к следующему.")
              start_grounding_step(next_step)
            else
              complete_grounding_practice
            end
          end
          
        when 'day_11_restart_grounding'
          start_grounding_exercise
          
        when 'grounding_exercise_completed', 'day_11_complete_grounding'
          complete_grounding_practice
          
        when /^day_11_challenge_(\d+)$/
          handle_challenge_selection($1)
          
        when 'day_11_no_challenges'
          # МЕНЯЕМ СОСТОЯНИЕ после выбора "нет трудностей"
          @user.set_self_help_step("day_#{DAY_NUMBER}_reflection_done")
          send_message(text: "🌟 Отлично! У вас получилась продуктивная практика!")
          send_message(
            text: "Завершаем День 11?",
            reply_markup: day_11_final_completion_markup
          )
          
        when 'day_11_complete_exercise', 'day_11_exercise_completed'
          complete_exercise
          
        when 'day_11_show_entries'
          show_previous_grounding_entries
          
        when 'day_11_help_tips'
          send_message(
            text: "💡 *Советы для эффективной практики:*\n\n• Делайте паузы между шагами\n• Будьте конкретны в описаниях\n• Используйте разные органы чувств каждый раз\n• Практикуйте в разных местах\n• Не торопитесь — качество важнее скорости",
            parse_mode: 'Markdown'
          )
          
        when 'day_11_emergency_mode'
          send_message(
            text: "🚨 *Экстренный режим заземления:*\n\nЕсли чувствуете панику или диссоциацию:\n1. Скажите себе: \"Я использую технику заземления\"\n2. Начинайте с 5 вещей, которые видите\n3. Дышите медленно и глубоко\n4. Помните: это пройдет\n\nВы можете сделать это прямо сейчас.",
            parse_mode: 'Markdown',
            reply_markup: day_11_grounding_start_markup
          )
          
        else
          log_warn("Unknown button callback: #{callback_data}")
          send_message(text: "Неизвестная команда.")
        end
      end
      
      # ===== ОБРАБОТКА ТЕКСТОВОГО ВВОДА =====
      
      def handle_text_input(input_text)
        log_info("Handling text input for day 11: #{input_text}")
        
        current_state = @user.self_help_state
        
        # Определяем, какой ввод ожидается
        case current_state
        when "day_11_waiting_for_seen"
          return handle_grounding_input(input_text)
          
        when "day_11_waiting_for_touched"
          return handle_grounding_input(input_text)
          
        when "day_11_waiting_for_heard"
          return handle_grounding_input(input_text)
          
        when "day_11_waiting_for_smelled"
          return handle_grounding_input(input_text)
          
        when "day_11_waiting_for_tasted"
          return handle_grounding_input(input_text)
          
        when "day_11_grounding_completed", "day_11_reflection_done", "day_11_completed"
          # Если практика уже завершена
          send_message(
            text: "✅ Практика заземления уже завершена. Вы можете:\n• Просмотреть свои практики\n• Начать новую практику\n• Завершить день 11",
            reply_markup: day_11_final_completion_markup
          )
          return true
        end
        
        log_warn("No text input handler for current state: #{current_state}")
        false
      end
      
      # Метод для совместимости с SelfHelpFacade
      def handle_smart_input(text)
        handle_text_input(text)
      end
      
      def handle_resume_from_step(step)
        case step
        when 'intro'
          deliver_intro
        when 'exercise_explanation'
          deliver_exercise
        when 'grounding_benefits'
          show_grounding_benefits
        when 'completion'
          show_completion_message
        else
          deliver_exercise
        end
      end
      
      def show_intro_without_state
        send_message(text: DAY_STEPS['intro'][:title], parse_mode: 'Markdown')
        send_message(text: DAY_STEPS['intro'][:instruction], parse_mode: 'Markdown')
        send_message(
          text: statistics_message,
          parse_mode: 'Markdown'
        )
        send_message(
          text: "Готовы освоить технику экстренного заземления?",
          reply_markup: day_11_content_markup
        )
      end
      
      def propose_next_day_with_restriction
        next_day = 12
        
        # Проверяем, можно ли начать следующий день
        can_start_result = @user.can_start_day?(next_day)
        
        if can_start_result == true
          message = "🎯 **Следующий шаг: День #{next_day}**\n\n✅ *Доступен сейчас!*\n\n**Что вас ждет:**\n• 💝 Медитация на самосострадание\n• 🤗 Развитие доброты к себе\n• 😌 Снижение самокритики\n• 🌟 Укрепление психологической устойчивости\n\nВы можете начать следующий день прямо сейчас."
          
          button_text = "💝 Начать День #{next_day}"
          callback_data = "start_day_#{next_day}_from_proposal"
        else
          error_message = can_start_result.is_a?(Array) ? can_start_result.join("\n") : can_start_result
          
          message = "🎯 **Следующий шаг: День #{next_day}**\n\n⏱️ *Ограничение:* #{error_message}\n\n**Пока ждете, можете:**\n• 🌍 Практиковать технику заземления в разных ситуациях\n• 📚 Просмотреть свои предыдущие практики\n• 🔄 Экспериментировать с разными сенсорными ощущениями\n• 📊 Посмотреть статистику (/progress)\n\n*Следующий день будет автоматически доступен, когда пройдет достаточно времени.*"
          
          button_text = "⏱️ Проверить доступность Дня #{next_day}"
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
          }
        )
      end
      
      private

      def format_sense_items(items, max_items = 2)
        return "не указаны" if items.blank?
        
        if items.is_a?(Array)
          display_items = items.first(max_items)
          display_text = display_items.join(', ')
          display_text += "..." if items.length > max_items
          display_text
        elsif items.is_a?(String)
          # Если строка, попробуем разбить
          items_array = items.split(/[,;.\s\n]+/).reject(&:blank?)
          if items_array.any?
            display_items = items_array.first(max_items)
            display_text = display_items.join(', ')
            display_text += "..." if items_array.length > max_items
            display_text
          else
            items
          end
        else
          items.to_s
        end
      end
      
      def get_next_grounding_step(current_step)
        steps_order = GROUNDING_STEPS.keys
        current_index = steps_order.index(current_step)
        
        return steps_order[current_index + 1] if current_index && current_index < steps_order.length - 1
        nil
      end
      
      def save_grounding_entry
        begin
          seen_items = get_day_data('seen_items') || []
          touched_items = get_day_data('touched_items') || []
          heard_items = get_day_data('heard_items') || []
          smelled_items = get_day_data('smelled_items') || []
          tasted_items = get_day_data('tasted_items') || []
          
          GroundingExerciseEntry.create!(
            user: @user,
            entry_date: Date.current,
            seen: seen_items,
            touched: touched_items,
            heard: heard_items,
            smelled: smelled_items,
            tasted: tasted_items
          )
          
          log_info("Saved grounding entry")
          store_day_data('entry_id', GroundingExerciseEntry.last&.id)
          
          true
        rescue => e
          log_error("Failed to save grounding entry", e)
          false
        end
      end
      
      def clear_grounding_data
        GROUNDING_STEPS.keys.each do |step|
          store_day_data("#{step}_items", nil)
          store_day_data("#{step}_completed", nil)
        end
        store_day_data('current_grounding_step', nil)
        store_day_data('grounding_started_at', nil)
        store_day_data('grounding_completed', nil)
        store_day_data('completion_time', nil)
      end
      
      # Вспомогательные методы разметки
      def day_11_content_markup
        TelegramMarkupHelper.day_11_content_markup
      end
      
      def day_11_grounding_start_markup
        TelegramMarkupHelper.day_11_grounding_start_markup
      end
      
      def day_11_input_markup
        TelegramMarkupHelper.day_11_input_markup
      end
      
      def day_11_challenges_markup
        TelegramMarkupHelper.day_11_challenges_markup
      end
      
      def day_11_final_completion_markup
        TelegramMarkupHelper.day_11_final_completion_markup
      end
      
      def statistics_message
        <<~MARKDOWN
          📊 *Научные данные о технике заземления 5-4-3-2-1:*
          
          • 🧠 **40-50%** — снижение интенсивности панических атак после 4 недель практики
          • 😌 **30-40%** — уменьшение общего уровня тревоги
          • ⏱️ **60-90 секунд** — время для заметного эффекта
          • 🎯 **70-80%** — эффективность при диссоциативных состояниях
          • 🔄 **4-6 недель** — регулярной практики для устойчивых результатов
          • 📈 **25-35%** — улучшение способности к саморегуляции
          
          *Источник: Исследования Journal of Anxiety Disorders, Cognitive Therapy and Research*
        MARKDOWN
      end
      
      def log_info(message)
        Rails.logger.info "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_warn(message)
        Rails.logger.warn "[#{self.class}] #{message} - User: #{@user.telegram_id}"
      end
      
      def log_error(message, error = nil)
        Rails.logger.error "[#{self.class}] #{message} - User: #{@user.telegram_id}"
        Rails.logger.error error.message if error
        Rails.logger.error error.backtrace.first(5).join("\n") if error
      end
    end
  end
end