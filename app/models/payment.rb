# app/models/payment.rb
class Payment < ApplicationRecord
  belongs_to :user
  
  # Статусы платежей
  enum status: {
    pending: 'pending',
    succeeded: 'succeeded', 
    canceled: 'canceled',
    refunded: 'refunded'
  }
  
  # Типы платежей
  enum payment_type: {
    subscription: 'subscription',
    donation: 'donation'
  }
  
  # Валидации
  validates :amount, numericality: { greater_than: 0 }
  validates :currency, inclusion: { in: ['RUB'] }
  validates :yookassa_payment_id, uniqueness: true, allow_nil: true
  
  # Перед созданием генерируем уникальный ID
  before_create :generate_uuid
  
  # Сумма в рублях
  def amount_in_rubles
    amount.to_f / 100
  end
  
  # Форматированная сумма
  def formatted_amount
    "#{amount_in_rubles.to_i}₽"
  end
  
  private
  
  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
