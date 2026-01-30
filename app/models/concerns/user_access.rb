# app/models/concerns/user_access.rb
module UserAccess
  extend ActiveSupport::Concern
  
  # Константы для уровней доступа
  ACCESS_LEVELS = {
    free: 'free',
    premium: 'premium',
    admin: 'admin'
  }.freeze
  
  # Константы для сообщений
  ACCESS_MESSAGES = {
    free: "🆓 Бесплатный доступ",
    premium: "⭐️ Премиум доступ",
    admin: "👑 Администратор"
  }.freeze
  
  # Продолжительность в днях
  TRIAL_DAYS = 3
  SUBSCRIPTION_DAYS = 30
end