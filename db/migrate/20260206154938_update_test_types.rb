class UpdateTestTypes < ActiveRecord::Migration[7.0]
  def up
    # Удаляем старый ENUM constraint если он есть
    execute <<-SQL
      ALTER TABLE tests 
      ALTER COLUMN test_type TYPE VARCHAR(255);
    SQL
    
    # Обновляем существующие записи
    execute <<-SQL
      UPDATE tests 
      SET test_type = 'luscher' 
      WHERE test_type = '1' OR test_type = 'luscher';
      
      UPDATE tests 
      SET test_type = 'standard' 
      WHERE test_type = '0' OR test_type = 'standard';
    SQL
  end

  def down
    # Можно вернуть обратно, но это не критично
    execute <<-SQL
      UPDATE tests 
      SET test_type = 'standard' 
      WHERE test_type IN ('anxiety', 'depression', 'eq', 'quiz');
    SQL
  end
end
