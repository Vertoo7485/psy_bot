module Telegram
  module Handlers
    class SubscriptionHandler < BaseHandler
      def handle
        if message_text == '/my_subscription' || message_text&.downcase&.include?('моя подписка')
          user.reload # Перезагружаем данные пользователя
          
          if user.has_active_premium?
            days_left = (user.subscription_ends_at.to_date - Date.today).to_i
            send_message(
              "🌟 У вас активна премиум-подписка!\n" \
              "📅 Действует до: #{user.subscription_ends_at.strftime('%d.%m.%Y')}\n" \
              "⏳ Осталось дней: #{days_left}\n\n" \
              "Спасибо, что с нами! 🚀"
            )
          else
            send_message(
              "У вас нет активной премиум-подписки.\n\n" \
              "🚀 Премиум-подписка дает:\n" \
              "• Безлимитные запросы к GPT-4\n" \
              "• Расширенную историю диалогов\n" \
              "• Приоритетную обработку\n\n" \
              "Нажмите /premium для оформления!"
            )
          end
          return true
        end
        
        false
      end
    end
  end
end
