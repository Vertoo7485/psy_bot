    class User < ApplicationRecord
      has_many :test_results
      has_many :tests, through: :test_results
      has_many :emotion_diary_entries, dependent: :destroy
      has_many :gratitude_entries, dependent: :destroy
      has_many :reflection_entries, dependent: :destroy

      # Для дневника эмоций
      attribute :current_diary_step, :string, default: nil
      attribute :diary_data, :json, default: {}

      # Для программы самопомощи
      attribute :self_help_program_step, :string, default: nil # nil, 'ready_for_tests', 'day_1_intro', 'day_1_completed', 'day_2_intro', 'day_2_exercise', 'day_2_completed', 'day_3_intro', 'day_3_gratitude', 'day_3_completed', 'program_completed'
      

      def self.find_or_create_from_telegram_message(from_data)
        find_or_create_by(telegram_id: from_data[:id]) do |u|
          u.first_name = from_data[:first_name]
          u.last_name = from_data[:last_name]
          u.username = from_data[:username]
        end
      end

      # Методы для управления состоянием программы самопомощи
      def set_self_help_step(step)
        update(self_help_program_step: step)
      end

      def get_self_help_step
        self_help_program_step
      end

      def store_self_help_data(key, value)
        update(self_help_program_data: self_help_program_data.merge(key => value))
      end

      def get_self_help_data(key)
        self_help_program_data[key]
      end

      def clear_self_help_program
        update(self_help_program_step: nil, self_help_program_data: {})
      end
    end
