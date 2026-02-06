# В файле db/migrate/20260104113643_add_test_result_optimizations.rb
# ДОБАВЬТЕ очистку дублей в начало метода up:

class AddTestResultOptimizations < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!
  
  def up
    say "Добавляем оптимизации для модели TestResult..."
    
    # ========== ОЧИСТКА ДУБЛЕЙ ПЕРЕД СОЗДАНИЕМ УНИКАЛЬНОГО ИНДЕКСА ==========
    say "Очищаю дубли в таблице answers..."
    
    # Находим дублирующиеся записи
    duplicate_sql = <<-SQL
      SELECT test_result_id, question_id, MIN(id) as keep_id
      FROM answers
      GROUP BY test_result_id, question_id
      HAVING COUNT(*) > 1
    SQL
    
    duplicates = ActiveRecord::Base.connection.execute(duplicate_sql)
    
    if duplicates.any?
      say "Найдено #{duplicates.count} групп дублей"
      
      duplicates.each do |dup|
        test_result_id = dup['test_result_id']
        question_id = dup['question_id']
        keep_id = dup['keep_id']
        
        # Удаляем все кроме первой записи
        delete_sql = <<-SQL
          DELETE FROM answers
          WHERE test_result_id = #{test_result_id}
            AND question_id = #{question_id}
            AND id != #{keep_id}
        SQL
        
        ActiveRecord::Base.connection.execute(delete_sql)
        say "  Очищены дубли для test_result_id: #{test_result_id}, question_id: #{question_id}"
      end
    else
      say "Дубли не найдены"
    end
    
    # ========== СОЗДАНИЕ ИНДЕКСОВ ==========
    
    # 1. Составные индексы для частых запросов
    unless index_exists?(:test_results, [:user_id, :completed_at])
      add_index :test_results, [:user_id, :completed_at], 
                algorithm: :concurrently,
                name: 'index_test_results_on_user_id_and_completed_at'
      say "✅ Добавлен составной индекс для user_id + completed_at"
    end
    
    # 2. Уникальный индекс для answers (теперь должен работать после очистки дублей)
    unless index_exists?(:answers, [:test_result_id, :question_id])
      add_index :answers, [:test_result_id, :question_id], 
                algorithm: :concurrently,
                unique: true,
                name: 'index_answers_on_test_result_id_and_question_id'
      say "✅ Добавлен уникальный индекс для answers"
    end
    
    # 3. Добавляем max_score в таблицу tests
    unless column_exists?(:tests, :max_score)
      add_column :tests, :max_score, :integer
      say "✅ Добавлен max_score в таблицу tests"
    end
    
    # 4. Индекс для score в test_results
    unless index_exists?(:test_results, :score)
      add_index :test_results, :score, 
                algorithm: :concurrently,
                where: "score IS NOT NULL",
                name: 'index_test_results_on_score'
      say "✅ Добавлен индекс для score (не NULL)"
    end
    
    # 5. Индекс для created_at в test_results
    unless index_exists?(:test_results, :created_at)
      add_index :test_results, :created_at, 
                algorithm: :concurrently,
                name: 'index_test_results_on_created_at'
      say "✅ Добавлен индекс для created_at"
    end
    
    say "\\n=== ОПТИМИЗАЦИИ ДЛЯ TEST_RESULT ДОБАВЛЕНЫ ==="
  end
  
  def down
    remove_index :test_results, name: 'index_test_results_on_user_id_and_completed_at', if_exists: true
    remove_index :answers, name: 'index_answers_on_test_result_id_and_question_id', if_exists: true
    remove_index :test_results, name: 'index_test_results_on_score', if_exists: true
    remove_index :test_results, name: 'index_test_results_on_created_at', if_exists: true
    
    if column_exists?(:tests, :max_score)
      remove_column :tests, :max_score
    end
  end
end