# В файле db/migrate/20260104112504_add_postgres_optimizations.rb
# ЗАМЕНИТЕ на этот код:

class AddPostgresOptimizations < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  
  def up
    say "Добавляем основные индексы для производительности..."
    
    # 1. USERS
    unless index_exists?(:users, :self_help_program_step)
      add_index :users, :self_help_program_step, 
                algorithm: :concurrently,
                name: 'index_users_on_self_help_program_step'
      say "✅ Добавлен индекс для users.self_help_program_step"
    end
    
    # 2. TEST_RESULTS
    unless index_exists?(:test_results, :completed_at)
      add_index :test_results, :completed_at, 
                algorithm: :concurrently,
                name: 'index_test_results_on_completed_at'
      say "✅ Добавлен индекс для test_results.completed_at"
    end
    
    # 3. ANSWERS
    unless index_exists?(:answers, :test_result_id)
      add_index :answers, :test_result_id, 
                algorithm: :concurrently,
                name: 'index_answers_on_test_result_id'
      say "✅ Добавлен индекс для answers.test_result_id"
    end
    
    unless index_exists?(:answers, :answer_option_id)
      add_index :answers, :answer_option_id, 
                algorithm: :concurrently,
                name: 'index_answers_on_answer_option_id'
      say "✅ Добавлен индекс для answers.answer_option_id"
    end
    
    # 4. QUESTIONS - используем id для порядка, так как position нет
    unless index_exists?(:questions, :test_id)
      add_index :questions, :test_id, 
                algorithm: :concurrently,
                name: 'index_questions_on_test_id'
      say "✅ Добавлен индекс для questions.test_id"
    end
    
    # 5. ANSWER_OPTIONS - колонки value может не быть, проверяем
    if column_exists?(:answer_options, :value)
      unless index_exists?(:answer_options, [:question_id, :value])
        add_index :answer_options, [:question_id, :value], 
                  algorithm: :concurrently,
                  name: 'index_answer_options_on_question_id_and_value'
        say "✅ Добавлен индекс для answer_options.question_id + value"
      end
    else
      say "⚠️ Колонка answer_options.value не существует"
      # Добавляем индекс только по question_id
      unless index_exists?(:answer_options, :question_id)
        add_index :answer_options, :question_id, 
                  algorithm: :concurrently,
                  name: 'index_answer_options_on_question_id'
        say "✅ Добавлен индекс для answer_options.question_id"
      end
    end
    
    say "\\n=== ОСНОВНЫЕ ИНДЕКСЫ ДОБАВЛЕНЫ ==="
  end
  
  def down
    remove_index :users, name: 'index_users_on_self_help_program_step', if_exists: true
    remove_index :test_results, name: 'index_test_results_on_completed_at', if_exists: true
    remove_index :answers, name: 'index_answers_on_test_result_id', if_exists: true
    remove_index :answers, name: 'index_answers_on_answer_option_id', if_exists: true
    remove_index :questions, name: 'index_questions_on_test_id', if_exists: true
    remove_index :answer_options, name: 'index_answer_options_on_question_id_and_value', if_exists: true
    remove_index :answer_options, name: 'index_answer_options_on_question_id', if_exists: true
  end
end