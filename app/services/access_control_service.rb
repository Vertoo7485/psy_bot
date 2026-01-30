# app/services/access_control_service.rb
class AccessControlService
  # Кастомные ошибки для разных типов отказа в доступе
  class AccessDeniedError < StandardError
    attr_reader :user
    
    def initialize(message = "Доступ запрещен", user = nil)
      super(message)
      @user = user
    end
  end
  
  class TrialExpiredError < StandardError
    def initialize(message = "Пробный период закончился")
      super(message)
    end
  end
  
  class SubscriptionExpiredError < StandardError
    def initialize(message = "Подписка закончилась")
      super(message)
    end
  end
  
  class NotPremiumError < StandardError
    def initialize(message = "Необходим премиум доступ")
      super(message)
    end
  end
  
  attr_reader :user
  
  def initialize(user)
    @user = user
  end
  
  # === ОСНОВНЫЕ МЕТОДЫ ПРОВЕРКИ ===
  
  # Основной метод проверки доступа к программе самопомощи
  def check_self_help_access!
    # Админы всегда имеют доступ
    return true if @user.admin?
    
    # Проверяем, является ли пользователь премиум
    unless @user.premium?
      raise NotPremiumError, 
        "❌ *Для доступа к программе самопомощи необходим премиум доступ*\n\n" \
        "Сейчас у вас есть бесплатный доступ, который включает:\n" \
        "• 📋 Все тесты\n" \
        "• 📔 Дневник эмоций\n\n" \
        "Премиум доступ добавляет:\n" \
        "• ⭐️ 28-дневную программу самопомощи\n" \
        "• 🧘‍♀️ Все дополнительные упражнения\n\n" \
        "Для получения доступа обратитесь к администратору."
    end
    
    # Проверяем, активен ли доступ
    unless @user.is_active
      raise AccessDeniedError.new(
        "❌ *Ваш доступ временно приостановлен*\n\n" \
        "Обратитесь к администратору для уточнения деталей.",
        @user
      )
    end
    
    # Проверяем trial период
    if @user.trial_ends_at && @user.trial_ends_at <= Time.current
      raise TrialExpiredError,
        "⏰ *Ваш пробный период закончился*\n\n" \
        "Вы использовали 3 бесплатных дня программы самопомощи.\n\n" \
        "Для продолжения программы приобретите подписку.\n" \
        "Обратитесь к администратору."
    end
    
    # Проверяем подписку
    if @user.subscription_ends_at && @user.subscription_ends_at <= Time.current
      raise SubscriptionExpiredError,
        "📅 *Ваша подписка закончилась*\n\n" \
        "Срок действия вашей подписки истек.\n\n" \
        "Для возобновления доступа к программе самопомощи " \
        "приобретите подписку.\n" \
        "Обратитесь к администратору."
    end
    
    # Если все проверки пройдены
    true
  end
  
  # Проверка доступа к конкретному дню программы
  def can_start_day?(day_number)
    begin
      check_self_help_access!
      
      # Используем существующую проверку пользователя
      result = @user.can_start_day?(day_number)
      
      if result == true
        true
      else
        # result содержит массив ошибок от can_start_day?
        result.is_a?(Array) ? result.join("\n") : result
      end
      
    rescue NotPremiumError, AccessDeniedError, 
           TrialExpiredError, SubscriptionExpiredError => e
      e.message
    end
  end
  
  # Проверка доступа к тестам (всегда доступны)
  def can_access_tests?
    true # Тесты доступны всем
  end
  
  # Проверка доступа к дневнику эмоций (всегда доступен)
  def can_access_diary?
    true # Дневник доступен всем
  end
  
  # === МЕТОДЫ ДЛЯ АДМИНИСТРАТОРОВ ===
  
  # Активация premium доступа админом
  def activate_premium!(days: 30, admin_user: nil)
    # Проверяем права админа
    unless admin_user&.admin?
      raise AccessDeniedError.new("Только администратор может активировать доступ", admin_user)
    end
    
    # Активируем премиум доступ
    @user.activate_premium!(days: days)
    
    # Логируем действие
    Rails.logger.info "Admin #{admin_user.id} activated premium for user #{@user.id} for #{days} days"
    
    true
  end
  
  # Деактивация premium доступа
  def deactivate_premium!(admin_user: nil)
    # Проверяем права админа
    unless admin_user&.admin?
      raise AccessDeniedError.new("Только администратор может деактивировать доступ", admin_user)
    end
    
    # Деактивируем
    @user.deactivate_premium!
    
    # Логируем действие
    Rails.logger.info "Admin #{admin_user.id} deactivated premium for user #{@user.id}"
    
    true
  end
  
  # Установка trial периода
  def set_trial!(days: 3, admin_user: nil)
    # Если указан админ, проверяем его права
    if admin_user && !admin_user.admin?
      raise AccessDeniedError.new("Только администратор может устанавливать trial", admin_user)
    end
    
    # Устанавливаем trial
    @user.activate_trial!(days: days)
    
    # Логируем действие
    log_msg = "Trial set for user #{@user.id} for #{days} days"
    log_msg += " by admin #{admin_user.id}" if admin_user
    Rails.logger.info log_msg
    
    true
  end
  
  # Продление подписки
  def extend_subscription!(days: 30, admin_user: nil)
    # Проверяем права админа
    unless admin_user&.admin?
      raise AccessDeniedError.new("Только администратор может продлевать подписки", admin_user)
    end
    
    # Продлеваем подписку
    @user.extend_subscription!(days: days)
    
    # Логируем действие
    Rails.logger.info "Admin #{admin_user.id} extended subscription for user #{@user.id} for #{days} days"
    
    true
  end
  
  # Назначение администратором
  def make_admin!(admin_user: nil)
    # Проверяем права админа
    unless admin_user&.admin?
      raise AccessDeniedError.new("Только администратор может назначать других администраторов", admin_user)
    end
    
    # Назначаем админом
    @user.make_admin!
    
    # Логируем действие
    Rails.logger.info "Admin #{admin_user.id} promoted user #{@user.id} to admin"
    
    true
  end
  
  # === СТАТИЧЕСКИЕ МЕТОДЫ ДЛЯ CRON ЗАДАЧ ===
  
  # Деактивация истёкших подписок (для ежедневного cron)
  def self.deactivate_expired_subscriptions
    expired_users = User.with_expired_subscription
    
    count = 0
    expired_users.each do |user|
      begin
        user.deactivate_premium!
        count += 1
        
        Rails.logger.info "Automatically deactivated expired subscription for user #{user.id}"
        
        # Здесь можно добавить отправку уведомления пользователю
        # notify_user_about_expired_subscription(user)
        
      rescue => e
        Rails.logger.error "Failed to deactivate subscription for user #{user.id}: #{e.message}"
      end
    end
    
    count
  end
  
  # Деактивация истёкших trial (для ежедневного cron)
  def self.deactivate_expired_trials
    expired_users = User.with_expired_trial
    
    count = 0
    expired_users.each do |user|
      begin
        user.deactivate_premium!
        count += 1
        
        Rails.logger.info "Automatically deactivated expired trial for user #{user.id}"
        
        # Здесь можно добавить отправку уведомления пользователю
        # notify_user_about_expired_trial(user)
        
      rescue => e
        Rails.logger.error "Failed to deactivate trial for user #{user.id}: #{e.message}"
      end
    end
    
    count
  end
  
  # Полная очистка (деактивация всего истёкшего)
  def self.cleanup_expired_access
    subs = deactivate_expired_subscriptions
    trials = deactivate_expired_trials
    
    {
      expired_subscriptions: subs,
      expired_trials: trials,
      total: subs + trials
    }
  end
  
  # Получение статистики системы
  def self.statistics
    {
      total_users: User.count,
      free_users: User.free_users.count,
      premium_users: User.premium_users.count,
      admin_users: User.admin_users.count,
      active_premium_users: User.with_active_subscription.count,
      active_trial_users: User.with_active_trial.count,
      inactive_users: User.inactive_users.count,
      users_with_expired_subscription: User.with_expired_subscription.count,
      users_with_expired_trial: User.with_expired_trial.count,
      
      # Дополнительная статистика
      users_created_today: User.where('created_at >= ?', Time.current.beginning_of_day).count,
      users_created_this_week: User.where('created_at >= ?', 1.week.ago).count,
      users_created_this_month: User.where('created_at >= ?', 1.month.ago).count
    }
  end
  
  # Поиск пользователей для админа
  def self.search_users(query, limit: 20)
    return User.none if query.blank?
    
    search_term = "%#{query.downcase}%"
    
    User.where(
      "LOWER(first_name) LIKE ? OR " \
      "LOWER(last_name) LIKE ? OR " \
      "LOWER(username) LIKE ? OR " \
      "CAST(telegram_id AS TEXT) LIKE ?",
      search_term, search_term, search_term, search_term
    ).limit(limit)
  end
  
  # Форматирование информации о пользователе
  def self.format_user_info(user, detailed: false)
    info = "👤 *#{user.first_name} #{user.last_name}*"
    info += " (@#{user.username})" if user.username.present?
    info += "\n🆔 ID: `#{user.telegram_id}`"
    info += "\n📅 Регистрация: #{user.created_at.strftime('%d.%m.%Y %H:%M')}"
    info += "\n#{user.access_info}"
    
    if detailed
      # Прогресс по программе
      completed_days = user.completed_days || []
      info += "\n📊 Прогресс: #{completed_days.size}/28 дней"
      
      if completed_days.any?
        info += "\n✅ Последний завершенный: День #{completed_days.max}"
      end
      
      # Текущий статус
      if user.self_help_program_step.present?
        info += "\n📍 Текущий шаг: #{user.self_help_program_step}"
      end
      
      # Информация о доступе
      if user.premium?
        if user.trial_ends_at
          status = user.trial_active? ? "✅ Активен" : "❌ Истёк"
          info += "\n⏰ Trial: #{status} (до #{user.trial_ends_at.strftime('%d.%m.%Y')})"
        end
        
        if user.subscription_ends_at
          status = user.subscription_active? ? "✅ Активна" : "❌ Истекла"
          info += "\n📅 Подписка: #{status} (до #{user.subscription_ends_at.strftime('%d.%m.%Y')})"
        end
        
        if user.premium_activated_at
          info += "\n⭐️ Активирован: #{user.premium_activated_at.strftime('%d.%m.%Y')}"
        end
      end
      
      # Последняя активность
      if user.active_session&.last_activity_at
        info += "\n⏰ Последняя активность: #{user.active_session.last_activity_at.strftime('%d.%m.%Y %H:%M')}"
      end
    end
    
    info
  end
end