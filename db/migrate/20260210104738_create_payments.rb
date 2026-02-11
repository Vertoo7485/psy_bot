class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string :currency, default: 'RUB', null: false
      t.string :status, default: 'pending', null: false
      t.string :payment_type, null: false
      t.string :yookassa_payment_id
      t.string :confirmation_url
      t.string :uuid
      t.text :metadata
      
      t.timestamps
      
      t.index :yookassa_payment_id, unique: true
      t.index :uuid, unique: true
      t.index :status
      t.index :payment_type
    end
  end
end
