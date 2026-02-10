# app/services/telegram/handlers/payment_handler.rb
module Telegram
  module Handlers
    class PaymentHandler < BaseHandler
      CALLBACK_PATTERN = /^payment_/
      
      def process
        case @callback_data
        when 'payment_premium'
          handle_premium_payment
        when 'premium_not_ready'
          handle_premium_not_ready
	        when /^payment_check_(\d+)$/
          handle_payment_check($1)
        else
          answer_callback_query("Неизвестный тип платежа", show_alert: true)
        end
      end
      
      private
      
      def handle_premium_payment
        show_premium_info
      end
      
      def show_premium_info
        message = "✨ *ПРЕМИУМ ПОДПИСКА*\n" \
                  "──────────────\n" \
                  "💎 *499₽ в месяц*\n\n" \
                  "🎯 *Что включено:*\n" \
                  "✓ Расширенная программа упражнений\n" \
                  "✓ Персональные рекомендации\n" \
                  "✓ Приоритетная поддержка\n" \
                  "✓ Новые функции первыми\n" \
                  "✓ Эксклюзивные техники\n\n" \
                  "💳 *Оплата через ЮKassa (безопасно)*"
        
        markup = {
          inline_keyboard: [
            [{ text: "✅ ПОДКЛЮЧИТЬ ПОДПИСКУ", callback_data: "premium_not_ready" }],
            [{ text: "⬅️ Назад", callback_data: "back_to_main_menu" }]
          ]
        }
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown',
          reply_markup: markup.to_json
        )
        
        answer_callback_query("✨ Премиум подписка")
      end
      
      def handle_premium_not_ready
        begin
          # 1. Создаем платеж в базе
          payment = Payment.create!(
            user_id: @user.id,
            amount: 49900, # 499₽ в копейках
            currency: 'RUB',
            payment_type: :subscription,
            status: :pending
          )
          
          # 2. Создаем платеж в ЮKassa
          yookassa_service = Payments::YookassaService.new
          return_url = "https://t.me/#{ENV['BOT_USERNAME']}?start=payment_#{payment.id}"
          yookassa_service.create_payment(payment, return_url)
          
          # 3. Показываем кнопку для оплаты
          show_payment_button(payment)
          
        rescue => e
          Rails.logger.error "Premium payment error: #{e.message}"
          show_error_message(e)
        end
      end
      
      def show_payment_button(payment)
        message = "💳 *Переход к оплате*\n\n" \
                  "Нажмите кнопку ниже для безопасной оплаты через ЮKassa.\n" \
                  "Сумма: *499₽*\n\n" \
                  "После оплаты подписка активируется автоматически."
        
        markup = {
          inline_keyboard: [
            [{ text: "✅ ОПЛАТИТЬ 499₽", url: payment.confirmation_url }],
            [{ text: "🔄 Проверить статус", callback_data: "payment_check_#{payment.id}" }],
            [{ text: "⬅️ Назад", callback_data: "back_to_main_menu" }]
          ]
        }
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown',
          reply_markup: markup.to_json
        )
        
        answer_callback_query("Переход к оплате")
      end

      
            def handle_payment_check(payment_id)
        payment = Payment.find_by(id: payment_id)

        if payment.nil?
          answer_callback_query("Платеж #{payment_id} не найден", show_alert: true)
          return
        end

        message = "ℹ️ *Информация о платеже*\n\n" \
                  "ID: #{payment.id}\n" \
                  "Сумма: #{payment.amount}₽\n" \
                  "Статус: #{payment.status || 'неизвестен'}\n" \
                  "Yookassa ID: #{payment.yookassa_payment_id || 'не создан'}"

        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown'
        )

        answer_callback_query("Проверка завершена")
      end

      
      def show_error_message(error)
        message = "⚠️ *Ошибка создания платежа*\n\n" \
                  "Попробуйте позже или свяжитесь с поддержкой.\n" \
                  "Ошибка: #{error.message[0..100]}"
        
        @bot_service.send_message(
          chat_id: @chat_id,
          text: message,
          parse_mode: 'Markdown'
        )
        
        answer_callback_query("Ошибка", show_alert: true)
      end
    end
  end
end
