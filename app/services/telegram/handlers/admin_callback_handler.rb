# app/services/telegram/handlers/admin_callback_handler.rb

module Telegram
  module Handlers
    class AdminCallbackHandler < BaseHandler
      CALLBACK_PATTERN = /^admin:(\w+)(?::(\d+))?(?::(\d+))?$/
      
      def process
  Rails.logger.debug "[AdminCallbackHandler DEBUG] @callback_data: #{@callback_data.inspect}"
  Rails.logger.debug "[AdminCallbackHandler DEBUG] @matches: #{@matches.inspect}"
  
  # Проверяем что пользователь админ
  unless @user.admin?
    answer_callback_query("❌ Требуются права администратора")
    return
  end
  
  # ПРЯМОЙ ПАРСИНГ (игнорируем @matches от фабрики)
  # Используем CALLBACK_PATTERN напрямую
  match = @callback_data&.match(CALLBACK_PATTERN)
  
  unless match
    answer_callback_query("❌ Неизвестная админ-команда")
    return
  end
  
  action = match[1]  # activate, trial, deactivate, extend
  user_id = match[2]&.to_i
  days = match[3]&.to_i
  
  Rails.logger.info("[Telegram::Handlers::AdminCallbackHandler] Admin action: #{action}, user_id: #{user_id}, days: #{days}")
  
  case action
  when 'activate'
    handle_activate(user_id, days)
  when 'trial'
    handle_trial(user_id, days)
  when 'deactivate'
    handle_deactivate(user_id)
  when 'extend'
    handle_extend(user_id, days)
  else
    answer_callback_query("❌ Неизвестная админ-команда: #{action}")
  end
end
      
      private
      
      def handle_activate(user_id, days = 30)
        target_user = User.find_by(id: user_id)
        
        unless target_user
          answer_callback_query("❌ Пользователь не найден")
          return
        end
        
        begin
          access_service = AccessControlService.new(target_user)
          access_service.activate_premium!(days: days, admin_user: @user)
          
          answer_callback_query("✅ Премиум доступ активирован на #{days} дней")
          
          # Обновляем сообщение с информацией о пользователе
          update_user_info_message(target_user)
          
        rescue => e
          log_error("Failed to activate premium", e)
          answer_callback_query("❌ Ошибка: #{e.message}")
        end
      end
      
      def handle_trial(user_id, days = 3)
        target_user = User.find_by(id: user_id)
        
        unless target_user
          answer_callback_query("❌ Пользователь не найден")
          return
        end
        
        begin
          access_service = AccessControlService.new(target_user)
          access_service.set_trial!(days: days, admin_user: @user)
          
          answer_callback_query("✅ Trial установлен на #{days} дней")
          
          # Обновляем сообщение
          update_user_info_message(target_user)
          
        rescue => e
          log_error("Failed to set trial", e)
          answer_callback_query("❌ Ошибка: #{e.message}")
        end
      end
      
      def handle_deactivate(user_id)
        target_user = User.find_by(id: user_id)
        
        unless target_user
          answer_callback_query("❌ Пользователь не найден")
          return
        end
        
        begin
          access_service = AccessControlService.new(target_user)
          access_service.deactivate_premium!(admin_user: @user)
          
          answer_callback_query("✅ Доступ деактивирован")
          
          # Обновляем сообщение
          update_user_info_message(target_user)
          
        rescue => e
          log_error("Failed to deactivate premium", e)
          answer_callback_query("❌ Ошибка: #{e.message}")
        end
      end
      
      def handle_extend(user_id, days = 30)
        target_user = User.find_by(id: user_id)
        
        unless target_user
          answer_callback_query("❌ Пользователь не найден")
          return
        end
        
        begin
          access_service = AccessControlService.new(target_user)
          access_service.extend_subscription!(days: days, admin_user: @user)
          
          answer_callback_query("✅ Подписка продлена на #{days} дней")
          
          # Обновляем сообщение
          update_user_info_message(target_user)
          
        rescue => e
          log_error("Failed to extend subscription", e)
          answer_callback_query("❌ Ошибка: #{e.message}")
        end
      end
      
      def update_user_info_message(user)
        info = AccessControlService.format_user_info(user, detailed: true)
        
        # Кнопки действий
        markup = {
          inline_keyboard: [
            [
              { text: "✅ Активировать (30 дн)", callback_data: "admin:activate:#{user.id}:30" },
              { text: "⏰ Trial (3 дн)", callback_data: "admin:trial:#{user.id}:3" }
            ],
            [
              { text: "🔄 Продлить (30 дн)", callback_data: "admin:extend:#{user.id}:30" },
              { text: "❌ Деактивировать", callback_data: "admin:deactivate:#{user.id}" }
            ],
            [
              { text: "⬅️ Назад к списку", callback_data: "admin:users" }
            ]
          ]
        }.to_json
        
        edit_message(
          text: info,
          reply_markup: markup,
          parse_mode: 'Markdown'
        )
      rescue => e
        log_error("Failed to update message", e)
      end
    end
  end
end