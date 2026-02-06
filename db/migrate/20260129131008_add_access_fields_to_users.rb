# db/migrate/20250128123000_add_access_fields_to_users.rb
# (Ваша дата будет другой)

class AddAccessFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    # 1. Уровень доступа: free, premium, admin
    add_column :users, :access_level, :string, default: 'free', null: false
    
    # 2. Когда заканчивается подписка (для премиум пользователей)
    add_column :users, :subscription_ends_at, :datetime
    
    # 3. Когда заканчивается trial период (автоматически 3 дня)
    add_column :users, :trial_ends_at, :datetime
    
    # 4. Активен ли доступ (можно быстро отключить вручную)
    add_column :users, :is_active, :boolean, default: true, null: false
    
    # 5. Когда был активирован премиум доступ
    add_column :users, :premium_activated_at, :datetime
    
    # 6. Добавляем индексы для быстрого поиска
    add_index :users, :access_level
    add_index :users, :subscription_ends_at
    add_index :users, :trial_ends_at
    add_index :users, :is_active
  end
end