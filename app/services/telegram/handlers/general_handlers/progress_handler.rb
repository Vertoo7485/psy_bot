# app/services/telegram/handlers/general_handlers/progress_handler.rb
module Telegram
  module Handlers
    module GeneralHandlers
      class ProgressHandler < BaseHandler
        def process
          Rails.logger.info "[ProgressHandler DEBUG] Начало обработки /progress для user #{@user.id}"
          
          begin
            # 1. Собираем данные БЕЗОПАСНО
            completed_days = safe_completed_days
            completed_count = completed_days.size
            progress_percentage = safe_progress_percentage(completed_count)
            next_day = safe_next_available_day(completed_days)
            consecutive_days = safe_consecutive_days(completed_days)
            
            Rails.logger.info "[ProgressHandler DEBUG] Данные:"
            Rails.logger.info "  completed_days: #{completed_days}"
            Rails.logger.info "  completed_count: #{completed_count}"
            Rails.logger.info "  progress_percentage: #{progress_percentage}"
            Rails.logger.info "  next_day: #{next_day}"
            Rails.logger.info "  consecutive_days: #{consecutive_days}"
            
            # 2. Получаем визуальные элементы
            main_emoji = safe_main_emoji(progress_percentage)
            progress_bar = safe_progress_bar(progress_percentage)
            
            # 3. Информация о следующем дне
            next_day_info = safe_next_day_info(next_day, completed_days)
            
            # 4. Дополнительные инсайты
            insights = safe_insights(completed_count, consecutive_days)
            
            # 5. Формируем сообщение с красивым форматированием
            message = <<~MARKDOWN
#{main_emoji} *ВАШ ПРОГРЕСС В ПРОГРАММЕ*
═══════════════════════

#{progress_bar} *#{progress_percentage}%*

📈 *СТАТИСТИКА:*
├─ ✅ Завершено: **#{completed_count}/28 дней**
├─ 🔥 Серия дней: **#{consecutive_days} подряд**
├─ 🎯 Следующий: **День #{next_day}**

#{next_day_info}
═══════════════════════

💡 *ИНСАЙТ:*
#{insights}

#{safe_motivation_message(progress_percentage)}
═══════════════════════
_Используйте /program чтобы продолжить_
            MARKDOWN
            
            Rails.logger.info "[ProgressHandler DEBUG] Отправляем сообщение"
            send_message(text: message, parse_mode: 'Markdown')
            Rails.logger.info "[ProgressHandler DEBUG] Сообщение отправлено успешно"
            
          rescue => e
            Rails.logger.error "[ProgressHandler ERROR] #{e.message}"
            Rails.logger.error e.backtrace.first(5).join("\n")
            
            # Фолбэк сообщение (тоже улучшенное)
            fallback_message = <<~MARKDOWN
📊 *ВАШ ПРОГРЕСС*

✅ Завершено: **#{(@user.completed_days || []).size}/28 дней**

🎯 _Продолжайте участие в программе!_

💪 _Каждый день - шаг к цели._
            MARKDOWN
            
            send_message(text: fallback_message, parse_mode: 'Markdown')
          end
        end
        
        private
        
        def safe_completed_days
          @user.completed_days || []
        rescue => e
          Rails.logger.warn "[ProgressHandler] Ошибка в completed_days: #{e.message}"
          []
        end
        
        def safe_progress_percentage(completed_count)
          return 0 if completed_count == 0
          (completed_count.to_f / 28 * 100).round(1)
        rescue => e
          Rails.logger.warn "[ProgressHandler] Ошибка в progress_percentage: #{e.message}"
          0
        end
        
        def safe_next_available_day(completed_days)
          (1..28).each do |day|
            return day unless completed_days.include?(day)
          end
          1
        rescue => e
          Rails.logger.warn "[ProgressHandler] Ошибка в next_available_day: #{e.message}"
          1
        end
        
        def safe_consecutive_days(completed_days)
          return 0 if completed_days.empty?
          
          # Сортируем дни и проверяем последовательные
          sorted_days = completed_days.sort
          consecutive = 1
          
          sorted_days.each_cons(2) do |a, b|
            if b == a + 1
              consecutive += 1
            else
              break
            end
          end
          
          consecutive
        rescue => e
          Rails.logger.warn "[ProgressHandler] Ошибка в consecutive_days: #{e.message}"
          1
        end
        
        def safe_main_emoji(percentage)
          case percentage
          when 0
            "🎯"
          when 1..25
            "🚀"
          when 26..50
            "🌟"
          when 51..75
            "🔥"
          when 76..99
            "🏆"
          when 100
            "🎉"
          else
            "📊"
          end
        end
        
        def safe_progress_bar(percentage)
          filled_width = (percentage / 5).to_i
          filled_width = 20 if filled_width > 20
          empty_width = 20 - filled_width
          
          # Прогресс-бар с началом и концом
          bar = ""
          
          # Начало бара
          bar += "⏳ " if percentage < 100
          bar += "🏁 " if percentage == 100
          
          # Заполненная часть
          filled_char = get_progress_char(percentage)
          bar += (filled_char * filled_width)
          
          # Незаполненная часть  
          bar += ("▫️" * empty_width)
          
          bar
        end

        def get_progress_char(percentage)
          case percentage
          when 0..33   then "🟡"  # желтый
          when 34..66  then "🟠"  # оранжевый
          when 67..99  then "🔴"  # красный
          when 100     then "🟢"  # зеленый
          else "⚫"
          end
        end
        
        def get_filled_char(percentage)
          case percentage
          when 0..25
            "🔸"
          when 26..50
            "🟡"
          when 51..75
            "🟠"
          when 76..99
            "🔴"
          when 100
            "🟢"
          else
            "◼️"
          end
        end
        
        def safe_next_day_info(next_day, completed_days)
          # Если предыдущий день завершен
          if next_day > 1 && completed_days.include?(next_day - 1)
            begin
              # Проверяем время
              if @user.enough_time_passed?
                return "🎁 *День #{next_day} доступен!* - Нажмите /program чтобы начать"
              else
                time_left = @user.formatted_time_until_next_day rescue "несколько часов"
                return "⏳ *День #{next_day}* будет доступен через #{time_left}"
              end
            rescue => e
              Rails.logger.warn "[ProgressHandler] Ошибка в enough_time_passed?: #{e.message}"
              return "🔄 *День #{next_day}* скоро будет доступен"
            end
          else
            if next_day == 1
              return "🎯 *Начните с Дня 1!* - Используйте /program"
            else
              return "📝 *Сначала завершите День #{next_day - 1}*"
            end
          end
        end
        
        def safe_insights(completed_count, consecutive_days)
          if completed_count == 0
            "Это начало вашего пути! Первый шаг - самый важный."
          elsif completed_count < 7
            "Вы формируете новую привычку. Первая неделя - ключевая!"
          elsif consecutive_days >= 7
            "Отличная серия! #{consecutive_days} дней подряд - это сила привычки!"
          elsif completed_count >= 14
            "Вы прошли половину программы! Это огромное достижение."
          elsif completed_count >= 21
            "Финальная прямая! Осталось всего #{28 - completed_count} дней."
          else
            "Каждый завершенный день укрепляет ваши навыки."
          end
        end
        
        def safe_motivation_message(percentage)
          case percentage
          when 0
            "🚀 *Давайте начнем!* Ваш первый день ждет вас."
          when 1..25
            "🌟 *Отличное начало!* Каждый день приближает вас к цели."
          when 26..50
            "💪 *Вы набираете обороты!* Половина пути уже позади."
          when 51..75
            "🔥 *Невероятный прогресс!* Вы ближе к цели, чем думаете."
          when 76..99
            "🏆 *Финальный рывок!* Всего #{'%.1f' % (100 - percentage)}% до завершения!"
          when 100
            "🎉 *БРАВО!* Вы завершили 28-дневную программу! Это выдающееся достижение."
          else
            "💫 *Продолжайте движение!* Каждый шаг имеет значение."
          end
        end
      end
    end
  end
end