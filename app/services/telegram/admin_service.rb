# app/services/telegram/admin_service.rb
module Telegram
  class AdminService
    # Список доступных команд для справки
    ADMIN_COMMANDS = [
      '/admin help - Показать справку',
      '/admin users - Список последних пользователей',
      '/admin user @username - Информация о пользователе',
      '/admin activate @username [дней] - Активировать премиум',
      '/admin deactivate @username - Деактивировать пользователя',
      '/admin trial @username [дней] - Установить trial',
      '/admin extend @username [дней] - Продлить подписку',
      '/admin stats - Статистика системы',
      '/admin search имя - Поиск пользователей',
      '/admin broadcast сообщение - Рассылка всем'
    ].freeze
    
    def initialize(bot, message_data, user)
      @bot = bot
      @message_data = message_data
      @user = user
      @chat_id = message_data[:chat][:id]
      @text = message_data[:text].to_s
      @args = @text.split(' ')[1..-1] || []
    end
    
    def process
      # Проверяем, является ли пользователем админом
      unless @user.admin?
        send_message("❌ У вас нет прав администратора.")
        return
      end
      
      command = @args.first&.downcase
      
      case command
      when 'help', 'start', nil
        show_help
      when 'users'
        list_users
      when 'user'
        show_user_info
      when 'activate'
        activate_user
      when 'deactivate'
        deactivate_user
      when 'trial'
        set_trial
      when 'extend'
        extend_subscription
      when 'stats'
        show_stats
      when 'search'
        search_users
      when 'broadcast'
        broadcast_message
      else
        send_message("❌ Неизвестная команда. Используйте `/admin help`")
      end
      
    rescue => e
      error_message = "❌ Ошибка: #{e.message}"
      Rails.logger.error "Admin command error: #{e.message}\n#{e.backtrace.first(10).join("\n")}"
      send_message(error_message)
    end
    
    private
    
    # === КОМАНДЫ АДМИНА ===
    
    def show_help
      help_text = "👑 *Админ-панель бота*\n\n" \
                  "*Доступные команды:*\n" \
                  "```\n#{ADMIN_COMMANDS.join("\n")}\n```\n\n" \
                  "*Примеры использования:*\n" \
                  "• `/admin user @username` - информация о пользователе\n" \
                  "• `/admin activate @username 30` - активировать на 30 дней\n" \
                  "• `/admin trial username 7` - trial на 7 дней\n" \
                  "• `/admin search иван` - поиск по имени\n\n" \
                  "Используйте @username, ID или часть имени."
      
      send_message(help_text, parse_mode: 'Markdown')
    end
    
    def list_users
      users = User.order(created_at: :desc).limit(15)
      
      if users.empty?
        send_message("📭 В системе нет пользователей.")
        return
      end
      
      text = "👥 *Последние 15 пользователей:*\n\n"
      
      users.each_with_index do |user, index|
        emoji = case user.access_level
                when 'admin' then '👑'
                when 'premium' then '⭐️'
                else '🆓'
                end
        
        text += "#{index + 1}. #{emoji} #{user.first_name} #{user.last_name}"
        text += " (@#{user.username})" if user.username.present?
        text += " - #{user.access_info}\n"
        text += "   🆔 #{user.telegram_id} | 📅 #{user.created_at.strftime('%d.%m')}\n\n"
      end
      
      text += "Всего пользователей: #{User.count}"
      
      send_message(text, parse_mode: 'Markdown')
    end
    
    def show_user_info
      identifier = @args[1]
      
      unless identifier
        send_message("❌ Укажите username, ID или имя: `/admin user @username`")
        return
      end
      
      user = find_user(identifier)
      
      unless user
        send_message("❌ Пользователь не найден.")
        return
      end
      
      text = AccessControlService.format_user_info(user, detailed: true)
      
      # Кнопки для быстрых действий
      markup = {
        inline_keyboard: [
          [
            { text: "✅ Активировать 30д", callback_data: "admin:activate:#{user.id}:30" },
            { text: "⏰ Trial 3д", callback_data: "admin:trial:#{user.id}:3" }
          ],
          [
            { text: "❌ Деактивировать", callback_data: "admin:deactivate:#{user.id}" },
            { text: "📅 Продлить 30д", callback_data: "admin:extend:#{user.id}:30" }
          ],
          [
            { text: "📊 Статистика", callback_data: "admin:stats" },
            { text: "🔍 Поиск", callback_data: "admin:search" }
          ]
        ]
      }.to_json
      
      send_message(text, parse_mode: 'Markdown', reply_markup: markup)
    end
    
    def activate_user
      identifier = @args[1]
      days = @args[2]&.to_i || 30
      
      unless identifier
        send_message("❌ Укажите username: `/admin activate @username [дней=30]`")
        return
      end
      
      if days < 1 || days > 365
        send_message("❌ Количество дней должно быть от 1 до 365.")
        return
      end
      
      user = find_user(identifier)
      
      unless user
        send_message("❌ Пользователь не найден.")
        return
      end
      
      access_control = AccessControlService.new(user)
      access_control.activate_premium!(days: days, admin_user: @user)
      
      text = "✅ *Пользователь активирован!*\n\n"
      text += AccessControlService.format_user_info(user)
      text += "\n\nДоступ активирован на *#{days} дней*"
      text += "\nДействует до: *#{user.subscription_ends_at.strftime('%d.%m.%Y %H:%M')}*"
      
      send_message(text, parse_mode: 'Markdown')
      
      # Отправляем уведомление пользователю
      notify_user(user, 
        "🎉 *Ваш премиум доступ активирован!*\n\n" \
        "Теперь вам доступна вся программа самопомощи на *#{days} дней*.\n" \
        "Срок действия: до *#{user.subscription_ends_at.strftime('%d.%m.%Y')}*.\n\n" \
        "Приятного использования! 🌟"
      )
    end
    
    def deactivate_user
      identifier = @args[1]
      
      unless identifier
        send_message("❌ Укажите username: `/admin deactivate @username`")
        return
      end
      
      user = find_user(identifier)
      
      unless user
        send_message("❌ Пользователь не найден.")
        return
      end
      
      access_control = AccessControlService.new(user)
      access_control.deactivate_premium!(admin_user: @user)
      
      text = "❌ *Пользователь деактивирован!*\n\n"
      text += AccessControlService.format_user_info(user)
      
      send_message(text, parse_mode: 'Markdown')
      
      # Отправляем уведомление пользователю
      notify_user(user,
        "ℹ️ *Ваш премиум доступ приостановлен*\n\n" \
        "Обратитесь к администратору для уточнения деталей."
      )
    end
    
    def set_trial
      identifier = @args[1]
      days = @args[2]&.to_i || 3
      
      unless identifier
        send_message("❌ Укажите username: `/admin trial @username [дней=3]`")
        return
      end
      
      if days < 1 || days > 30
        send_message("❌ Количество дней trial должно быть от 1 до 30.")
        return
      end
      
      user = find_user(identifier)
      
      unless user
        send_message("❌ Пользователь не найден.")
        return
      end
      
      access_control = AccessControlService.new(user)
      access_control.set_trial!(days: days, admin_user: @user)
      
      text = "⏰ *Trial период установлен!*\n\n"
      text += AccessControlService.format_user_info(user)
      text += "\n\nTrial на *#{days} дней*"
      text += "\nДействует до: *#{user.trial_ends_at.strftime('%d.%m.%Y %H:%M')}*"
      
      send_message(text, parse_mode: 'Markdown')
      
      # Отправляем уведомление пользователю
      notify_user(user,
        "🎁 *Вам предоставлен пробный период!*\n\n" \
        "Теперь вам доступна вся программа самопомощи на *#{days} дней*.\n" \
        "Пробный период действует до: *#{user.trial_ends_at.strftime('%d.%m.%Y')}*.\n\n" \
        "Наслаждайтесь! 😊"
      )
    end
    
    def extend_subscription
      identifier = @args[1]
      days = @args[2]&.to_i || 30
      
      unless identifier
        send_message("❌ Укажите username: `/admin extend @username [дней=30]`")
        return
      end
      
      if days < 1 || days > 365
        send_message("❌ Количество дней должно быть от 1 до 365.")
        return
      end
      
      user = find_user(identifier)
      
      unless user
        send_message("❌ Пользователь не найден.")
        return
      end
      
      unless user.premium?
        send_message("❌ Пользователь не имеет премиум доступа.")
        return
      end
      
      access_control = AccessControlService.new(user)
      access_control.extend_subscription!(days: days, admin_user: @user)
      
      text = "📅 *Подписка продлена!*\n\n"
      text += AccessControlService.format_user_info(user)
      text += "\n\nПодписка продлена на *#{days} дней*"
      text += "\nНовая дата окончания: *#{user.subscription_ends_at.strftime('%d.%m.%Y %H:%M')}*"
      
      send_message(text, parse_mode: 'Markdown')
      
      # Отправляем уведомление пользователю
      notify_user(user,
        "🔄 *Ваша подписка продлена!*\n\n" \
        "Ваш премиум доступ продлен на *#{days} дней*.\n" \
        "Новая дата окончания: *#{user.subscription_ends_at.strftime('%d.%m.%Y')}*.\n\n" \
        "Спасибо, что остаетесь с нами! ❤️"
      )
    end
    
    def show_stats
      stats = AccessControlService.statistics
      
      text = "📊 *Статистика системы*\n\n"
      text += "👥 *Пользователи:*\n"
      text += "• Всего: #{stats[:total_users]}\n"
      text += "• Бесплатных: #{stats[:free_users]}\n"
      text += "• Премиум: #{stats[:premium_users]}\n"
      text += "• Админов: #{stats[:admin_users]}\n\n"
      
      text += "⭐️ *Активные подписки:*\n"
      text += "• Активных премиум: #{stats[:active_premium_users]}\n"
      text += "• Активных trial: #{stats[:active_trial_users]}\n"
      text += "• Истекших подписок: #{stats[:users_with_expired_subscription]}\n"
      text += "• Истекших trial: #{stats[:users_with_expired_trial]}\n"
      text += "• Неактивных: #{stats[:inactive_users]}\n\n"
      
      text += "📈 *Новые пользователи:*\n"
      text += "• Сегодня: #{stats[:users_created_today]}\n"
      text += "• За неделю: #{stats[:users_created_this_week]}\n"
      text += "• За месяц: #{stats[:users_created_this_month]}"
      
      send_message(text, parse_mode: 'Markdown')
    end
    
    def search_users
      query = @args[1..-1]&.join(' ')
      
      unless query && query.length >= 2
        send_message("❌ Введите минимум 2 символа для поиска: `/admin search имя`")
        return
      end
      
      users = AccessControlService.search_users(query, limit: 15)
      
      if users.empty?
        send_message("🔍 Пользователи не найдены по запросу: `#{query}`")
        return
      end
      
      text = "🔍 *Результаты поиска:* `#{query}`\n\n"
      
      users.each_with_index do |user, index|
        emoji = case user.access_level
                when 'admin' then '👑'
                when 'premium' then '⭐️'
                else '🆓'
                end
        
        text += "#{index + 1}. #{emoji} #{user.first_name} #{user.last_name}"
        text += " (@#{user.username})" if user.username.present?
        text += "\n   🆔 #{user.telegram_id} | #{user.access_info}\n\n"
      end
      
      text += "Найдено: #{users.count} пользователей"
      
      send_message(text, parse_mode: 'Markdown')
    end
    
    def broadcast_message
      message = @args[1..-1]&.join(' ')
      
      unless message && message.length >= 5
        send_message("❌ Введите сообщение для рассылки (минимум 5 символов):\n`/admin broadcast Ваше сообщение`")
        return
      end
      
      # Сохраняем сообщение для подтверждения
      @broadcast_message = message
      
      markup = {
        inline_keyboard: [
          [
            { text: "✅ Отправить всем (#{User.count})", callback_data: "admin:broadcast:confirm" },
            { text: "❌ Отмена", callback_data: "admin:broadcast:cancel" }
          ]
        ]
      }.to_json
      
      preview = message.length > 200 ? message[0..200] + "..." : message
      
      send_message(
        "📢 *Подтвердите рассылку:*\n\n" \
        "#{preview}\n\n" \
        "Отправить это сообщение всем *#{User.count}* пользователям?",
        parse_mode: 'Markdown',
        reply_markup: markup
      )
    end
    
    # === ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ===
    
    def find_user(identifier)
      # Убираем @ если есть
      identifier = identifier.to_s.gsub('@', '').strip
      
      # Пробуем найти разными способами
      
      # 1. По telegram_id (цифры)
      if identifier =~ /^\d+$/
        user = User.find_by(telegram_id: identifier.to_i)
        return user if user
      end
      
      # 2. По username (точное совпадение)
      user = User.find_by("LOWER(username) = ?", identifier.downcase)
      return user if user
      
      # 3. По имени/фамилии (частичное совпадение)
      users = User.where(
        "LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?",
        "%#{identifier.downcase}%", "%#{identifier.downcase}%"
      ).first
      
      users
    end
    
    def notify_user(user, message)
      begin
        @bot.send_message(
          chat_id: user.telegram_id,
          text: message,
          parse_mode: 'Markdown'
        )
        Rails.logger.info "Notification sent to user #{user.id}"
      rescue Telegram::Bot::Error => e
        Rails.logger.error "Failed to notify user #{user.id}: #{e.message}"
      end
    end
    
    def send_message(text, parse_mode: nil, reply_markup: nil)
      @bot.send_message(
        chat_id: @chat_id,
        text: text,
        parse_mode: parse_mode,
        reply_markup: reply_markup
      )
    end
  end
end