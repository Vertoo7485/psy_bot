# lib/tasks/access.rake
namespace :access do
  desc "Показать справку по командам управления доступом"
  task help: :environment do
    puts "=" * 60
    puts "КОМАНДЫ ДЛЯ УПРАВЛЕНИЯ СИСТЕМОЙ ДОСТУПА"
    puts "=" * 60
    puts
    puts "1. Назначение администратора:"
    puts "   rails access:make_admin[TELEGRAM_ID]"
    puts "   Пример: rails access:make_admin[123456789]"
    puts
    puts "2. Управление доступом пользователя:"
    puts "   rails access:activate[TELEGRAM_ID,ДНЕЙ]    - Активировать премиум"
    puts "   rails access:trial[TELEGRAM_ID,ДНЕЙ]       - Установить trial"
    puts "   rails access:deactivate[TELEGRAM_ID]       - Деактивировать"
    puts "   rails access:set_level[TELEGRAM_ID,УРОВЕНЬ] - Установить уровень"
    puts
    puts "3. Просмотр информации:"
    puts "   rails access:check[TELEGRAM_ID]            - Проверить доступ"
    puts "   rails access:stats                         - Статистика системы"
    puts "   rails access:list[ЛИМИТ]                   - Список пользователей"
    puts
    puts "4. Технические команды:"
    puts "   rails access:cleanup                       - Очистка истёкших"
    puts "   rails access:reset_all                     - Сбросить все доступы"
    puts
    puts "Уровни доступа: free, premium, admin"
    puts "По умолчанию trial: 3 дня, подписка: 30 дней"
    puts "=" * 60
  end

  desc "Сделать пользователя администратором"
  task :make_admin, [:telegram_id] => :environment do |t, args|
    telegram_id = args[:telegram_id]
    
    unless telegram_id
      puts "❌ Укажите Telegram ID: rails access:make_admin[123456789]"
      puts "   Найдите свой ID: rails access:find_my_id"
      exit 1
    end
    
    user = User.find_by(telegram_id: telegram_id)
    
    unless user
      puts "❌ Пользователь с ID #{telegram_id} не найден"
      puts "   Сначала отправьте сообщение боту, чтобы создать пользователя"
      exit 1
    end
    
    old_level = user.access_level
    user.make_admin!
    
    puts "✅ Пользователь назначен администратором!"
    puts "   👤 Имя: #{user.first_name} #{user.last_name}"
    puts "   📱 Telegram: @#{user.username}" if user.username
    puts "   🆔 ID: #{user.telegram_id}"
    puts "   📊 Уровень: #{old_level} → #{user.access_level}"
    puts "   📅 Создан: #{user.created_at.strftime('%d.%m.%Y %H:%M')}"
    puts
    puts "Теперь вы можете использовать команды:"
    puts "   В боте: /admin help"
    puts "   В консоли: rails access:help"
  end

  desc "Найти свой Telegram ID (отправьте сообщение боту сначала)"
  task find_my_id: :environment do
    users = User.order(created_at: :desc).limit(5)
    
    if users.empty?
      puts "❌ В базе нет пользователей"
      puts "   Сначала отправьте любое сообщение боту"
      exit 1
    end
    
    puts "=" * 60
    puts "ПОСЛЕДНИЕ ПОЛЬЗОВАТЕЛИ В БАЗЕ:"
    puts "=" * 60
    
    users.each_with_index do |user, index|
      puts "#{index + 1}. #{user.first_name} #{user.last_name}"
      puts "   🆔 ID: #{user.telegram_id}"
      puts "   📱 @#{user.username}" if user.username
      puts "   📊 Уровень: #{user.access_info}"
      puts "   📅 Регистрация: #{user.created_at.strftime('%d.%m.%Y %H:%M')}"
      puts
    end
    
    puts "=" * 60
    puts "Используйте команду:"
    puts "rails access:make_admin[ВАШ_ID]"
    puts "=" * 60
  end

  desc "Активировать премиум доступ пользователю"
  task :activate, [:telegram_id, :days] => :environment do |t, args|
    telegram_id = args[:telegram_id]
    days = args[:days]&.to_i || 30
    
    unless telegram_id
      puts "❌ Укажите Telegram ID: rails access:activate[123456789,30]"
      exit 1
    end
    
    if days < 1 || days > 365
      puts "❌ Количество дней должно быть от 1 до 365"
      exit 1
    end
    
    user = User.find_by(telegram_id: telegram_id)
    
    unless user
      puts "❌ Пользователь с ID #{telegram_id} не найден"
      exit 1
    end
    
    old_level = user.access_level
    user.activate_premium!(days: days)
    
    puts "✅ Премиум доступ активирован!"
    puts "   👤 Имя: #{user.first_name} #{user.last_name}"
    puts "   🆔 ID: #{user.telegram_id}"
    puts "   📊 Уровень: #{old_level} → #{user.access_level}"
    puts "   📅 Дней: #{days}"
    puts "   ⏰ Доступ до: #{user.subscription_ends_at.strftime('%d.%m.%Y %H:%M')}"
    
    if old_level == 'free'
      puts "   🎉 Пользователь переведен с бесплатного на премиум доступ!"
    end
  end

  desc "Установить trial период пользователю"
  task :trial, [:telegram_id, :days] => :environment do |t, args|
    telegram_id = args[:telegram_id]
    days = args[:days]&.to_i || 3
    
    unless telegram_id
      puts "❌ Укажите Telegram ID: rails access:trial[123456789,3]"
      exit 1
    end
    
    if days < 1 || days > 30
      puts "❌ Количество дней trial должно быть от 1 до 30"
      exit 1
    end
    
    user = User.find_by(telegram_id: telegram_id)
    
    unless user
      puts "❌ Пользователь с ID #{telegram_id} не найден"
      exit 1
    end
    
    old_level = user.access_level
    user.activate_trial!(days: days)
    
    puts "✅ Trial период установлен!"
    puts "   👤 Имя: #{user.first_name} #{user.last_name}"
    puts "   🆔 ID: #{user.telegram_id}"
    puts "   📊 Уровень: #{old_level} → #{user.access_level}"
    puts "   ⏰ Trial дней: #{days}"
    puts "   🎁 Доступ до: #{user.trial_ends_at.strftime('%d.%m.%Y %H:%M')}"
  end

  desc "Проверить доступ пользователя"
  task :check, [:telegram_id] => :environment do |t, args|
    telegram_id = args[:telegram_id]
    
    unless telegram_id
      puts "❌ Укажите Telegram ID: rails access:check[123456789]"
      exit 1
    end
    
    user = User.find_by(telegram_id: telegram_id)
    
    unless user
      puts "❌ Пользователь с ID #{telegram_id} не найден"
      exit 1
    end
    
    puts "=" * 60
    puts "ИНФОРМАЦИЯ О ДОСТУПЕ ПОЛЬЗОВАТЕЛЯ"
    puts "=" * 60
    puts
    puts "👤 Имя: #{user.first_name} #{user.last_name}"
    puts "📱 @#{user.username}" if user.username
    puts "🆔 Telegram ID: #{user.telegram_id}"
    puts "📅 Регистрация: #{user.created_at.strftime('%d.%m.%Y %H:%M')}"
    puts "📊 Уровень доступа: #{user.access_info}"
    puts
    
    puts "🔍 Проверки доступа:"
    puts "   • Администратор: #{user.admin? ? '✅ Да' : '❌ Нет'}"
    puts "   • Премиум доступ: #{user.premium? ? '✅ Да' : '❌ Нет'}"
    puts "   • Бесплатный доступ: #{user.free? ? '✅ Да' : '❌ Нет'}"
    puts "   • Активен: #{user.is_active ? '✅ Да' : '❌ Нет'}"
    puts "   • Trial активен: #{user.trial_active? ? '✅ Да' : '❌ Нет'}"
    puts "   • Подписка активна: #{user.subscription_active? ? '✅ Да' : '❌ Нет'}"
    puts "   • Может получить доступ к программе: #{user.can_access_self_help_program? ? '✅ Да' : '❌ Нет'}"
    puts
    
    if user.trial_ends_at
      puts "⏰ Trial период:"
      puts "   • Дата окончания: #{user.trial_ends_at.strftime('%d.%m.%Y %H:%M')}"
      puts "   • Осталось дней: #{user.days_until_trial_ends}"
      puts "   • Истёк: #{user.trial_ended? ? '✅ Да' : '❌ Нет'}"
      puts
    end
    
    if user.subscription_ends_at
      puts "📅 Подписка:"
      puts "   • Дата окончания: #{user.subscription_ends_at.strftime('%d.%m.%Y %H:%M')}"
      puts "   • Осталось дней: #{user.days_until_subscription_ends}"
      puts "   • Истекла: #{user.subscription_ended? ? '✅ Да' : '❌ Нет'}"
      puts
    end
    
    puts "📊 Прогресс по программе:"
    puts "   • Завершено дней: #{user.completed_days&.size || 0}/28"
    puts "   • Процент: #{user.progress_percentage}%"
    puts "   • Текущая серия: #{user.current_streak} дней"
    puts
    
    puts "=" * 60
  end

  desc "Показать статистику системы"
  task stats: :environment do
    stats = AccessControlService.statistics
    
    puts "=" * 60
    puts "СТАТИСТИКА СИСТЕМЫ ДОСТУПА"
    puts "=" * 60
    puts
    
    puts "👥 ПОЛЬЗОВАТЕЛИ:"
    puts "   • Всего: #{stats[:total_users]}"
    puts "   • Бесплатных: #{stats[:free_users]}"
    puts "   • Премиум: #{stats[:premium_users]}"
    puts "   • Админов: #{stats[:admin_users]}"
    puts "   • Неактивных: #{stats[:inactive_users]}"
    puts
    
    puts "⭐️ АКТИВНЫЕ ДОСТУПЫ:"
    puts "   • Активных премиум: #{stats[:active_premium_users]}"
    puts "   • Активных trial: #{stats[:active_trial_users]}"
    puts "   • Истекших подписок: #{stats[:users_with_expired_subscription]}"
    puts "   • Истекших trial: #{stats[:users_with_expired_trial]}"
    puts
    
    puts "📈 ДИНАМИКА:"
    puts "   • Сегодня: #{stats[:users_created_today]}"
    puts "   • За неделю: #{stats[:users_created_this_week]}"
    puts "   • За месяц: #{stats[:users_created_this_month]}"
    puts
    
    puts "=" * 60
  end

  desc "Список пользователей"
  task :list, [:limit] => :environment do |t, args|
    limit = args[:limit]&.to_i || 20
    
    users = User.order(created_at: :desc).limit(limit)
    
    if users.empty?
      puts "📭 В системе нет пользователей"
      exit 0
    end
    
    puts "=" * 60
    puts "СПИСОК ПОЛЬЗОВАТЕЛЕЙ (последние #{users.count})"
    puts "=" * 60
    puts
    
    users.each_with_index do |user, index|
      emoji = case user.access_level
              when 'admin' then '👑'
              when 'premium' then '⭐️'
              else '🆓'
              end
      
      active_icon = user.is_active ? '✅' : '❌'
      
      puts "#{index + 1}. #{emoji} #{active_icon} #{user.first_name} #{user.last_name}"
      puts "   📱 @#{user.username}" if user.username
      puts "   🆔 #{user.telegram_id}"
      puts "   📊 #{user.access_info}"
      puts "   📅 #{user.created_at.strftime('%d.%m.%Y %H:%M')}"
      
      if user.premium?
        if user.trial_ends_at
          puts "   ⏰ Trial до: #{user.trial_ends_at.strftime('%d.%m.%Y')}"
        end
        if user.subscription_ends_at
          puts "   📅 Подписка до: #{user.subscription_ends_at.strftime('%d.%m.%Y')}"
        end
      end
      
      puts
    end
    
    puts "=" * 60
    puts "Всего пользователей: #{User.count}"
    puts "=" * 60
  end

  desc "Очистка истёкших подписок и trial"
  task cleanup: :environment do
    puts "🧹 Начинаю очистку истёкших доступов..."
    
    result = AccessControlService.cleanup_expired_access
    
    puts "✅ Очистка завершена!"
    puts "   • Отключено подписок: #{result[:expired_subscriptions]}"
    puts "   • Отключено trial: #{result[:expired_trials]}"
    puts "   • Всего: #{result[:total]} пользователей"
    
    if result[:total] > 0
      puts
      puts "📝 Рекомендуется настроить cron задачу:"
      puts "   every :day, at: '3:00 am' do"
      puts "     rake 'access:cleanup'"
      puts "   end"
    end
  end

  desc "Сбросить все доступы к бесплатным (ОПАСНО!)"
  task reset_all: :environment do
    puts "⚠️  ВНИМАНИЕ: Эта команда сбросит ВСЕ доступы к бесплатным!"
    puts "    Все пользователи станут free, все подписки и trial будут удалены."
    puts
    
    print "Вы уверены? (введите 'yes' для подтверждения): "
    confirmation = STDIN.gets.chomp
    
    if confirmation.downcase != 'yes'
      puts "❌ Отменено"
      exit 0
    end
    
    puts "🔄 Начинаю сброс всех доступов..."
    
    count = User.where.not(access_level: 'free').update_all(
      access_level: 'free',
      subscription_ends_at: nil,
      trial_ends_at: nil,
      is_active: true
    )
    
    puts "✅ Сброс завершен!"
    puts "   • Обработано пользователей: #{count}"
    puts "   • Все пользователи теперь имеют бесплатный доступ"
  end
end