# app/services/payments/yookassa_service.rb
module Payments
  class YookassaService
    require 'yookassa'
    
    def initialize
      configure_yookassa
    end
    
    # Создание платежа в ЮKassa
    def create_payment(payment, return_url)
      Rails.logger.info "Creating Yookassa payment for payment_id: #{payment.id}"
      
      # Настройка клиента
      client = Yookassa.client
      
      # Создаем платеж
      response = Yookassa.payments.create(
        payment: {
          amount: {
            value: payment.amount.to_f / 100,
            currency: payment.currency
          },
          capture: true,
          confirmation: {
            type: 'redirect',
            return_url: return_url
          },
          description: payment_description(payment),
          metadata: {
            payment_id: payment.id,
            user_id: payment.user_id,
            payment_type: payment.payment_type
          }
        }
      )
      Rails.logger.info "Yookassa payment created: #{response.id}"
      
      # Сохраняем ID платежа из ЮKassa
      payment.update(
        yookassa_payment_id: response.id,
        confirmation_url: response.confirmation.confirmation_url
      )
      
      response
    rescue => e
      Rails.logger.error "Failed to create Yookassa payment: #{e.message}"
      raise
    end
    
    private
    
    def configure_yookassa
      Yookassa.configure do |config|
        config.shop_id = ENV['YOOKASSA_SHOP_ID']
        config.api_key = ENV['YOOKASSA_SECRET_KEY']
      end
    end
    
    def payment_description(payment)
      case payment.payment_type
      when 'subscription'
        "Премиум подписка на телеграм-бота психологической помощи"
      when 'donation'
        "Поддержка проекта телеграм-бота психологической помощи"
      else
        "Оплата услуг"
      end
    end
  end
end
