class ConvertLuscherChoicesToArrayAndAddIndexes < ActiveRecord::Migration[7.1]
  def up
    # Временно удаляем сериализацию, чтобы избежать ошибок
    change_column :test_results, :luscher_choices, :text
    
    # 1. Сначала проверим текущие данные
    execute <<~SQL
      DO $$
      DECLARE
        total_records INTEGER;
        empty_records INTEGER;
        non_empty_records INTEGER;
        luscher_test_id INTEGER;
      BEGIN
        -- Получаем ID теста Люшера из enum (luscher = 1)
        SELECT id INTO luscher_test_id 
        FROM tests 
        WHERE test_type = 1  -- luscher = 1 в enum
        LIMIT 1;
        
        SELECT COUNT(*) INTO total_records FROM test_results;
        SELECT COUNT(*) INTO empty_records FROM test_results 
        WHERE luscher_choices IS NULL OR trim(luscher_choices) = '';
        SELECT COUNT(*) INTO non_empty_records FROM test_results 
        WHERE luscher_choices IS NOT NULL AND trim(luscher_choices) != '';
        
        RAISE NOTICE 'Тест Люшера ID: %', luscher_test_id;
        RAISE NOTICE 'Всего записей: %', total_records;
        RAISE NOTICE 'Пустых записей: %', empty_records;
        RAISE NOTICE 'Записей с данными: %', non_empty_records;
      END $$;
    SQL
    
    # 2. Создаем временный столбец с массивом
    add_column :test_results, :luscher_choices_array, :text, array: true, default: []
    
    # 3. Конвертируем данные из text в text[] с учетом уже существующих массивов
    execute <<~SQL
      UPDATE test_results 
      SET luscher_choices_array = 
        CASE 
          WHEN luscher_choices IS NULL THEN '{}'
          WHEN trim(luscher_choices) = '' THEN '{}'
          -- Проверяем, не массив ли уже (начинается с [)
          WHEN luscher_choices LIKE '[%' THEN 
            -- Пытаемся разобрать как JSON массив
            CASE 
              WHEN luscher_choices LIKE '["%' THEN 
                string_to_array(
                  trim(
                    translate(luscher_choices, '[]"', '')
                  ), 
                  ','
                )
              ELSE '{}'
            END
          ELSE string_to_array(trim(luscher_choices), ',')
        END;
    SQL
    
    # 4. Удаляем старый столбец
    remove_column :test_results, :luscher_choices
    
    # 5. Переименовываем новый столбец
    rename_column :test_results, :luscher_choices_array, :luscher_choices
    
    # 6. Добавляем индекс GIN для быстрого поиска по массиву
    add_index :test_results, :luscher_choices, using: 'gin'
    
    # 7. Добавляем индекс для часто используемых запросов
    add_index :test_results, [:user_id, :test_id, :completed_at],
              name: 'index_test_results_on_user_and_test_and_completed'
    
    # 8. Получаем ID теста Люшера для частичного индекса
    luscher_test_id = select_value("SELECT id FROM tests WHERE test_type = 1 LIMIT 1")
    
    if luscher_test_id
      # 9. Добавляем индекс для незавершенных тестов Люшера
      add_index :test_results, [:test_id, :completed_at], 
                where: "test_id = #{luscher_test_id} AND completed_at IS NULL",
                name: 'index_test_results_on_luscher_test_null_completed'
    end
    
    # 10. Добавляем комментарий к столбцу для документации
    execute <<~SQL
      COMMENT ON COLUMN test_results.luscher_choices 
      IS 'Массив выбранных цветов для теста Люшера. Формат: ["dark_blue", "red_yellow", ...]';
    SQL
    
    # 11. Проверяем результат
    execute <<~SQL
      DO $$
      DECLARE
        array_count INTEGER;
        empty_arrays INTEGER;
        non_empty_arrays INTEGER;
        invalid_arrays INTEGER;
      BEGIN
        SELECT COUNT(*) INTO array_count FROM test_results;
        SELECT COUNT(*) INTO empty_arrays FROM test_results 
        WHERE luscher_choices = '{}';
        SELECT COUNT(*) INTO non_empty_arrays FROM test_results 
        WHERE array_length(luscher_choices, 1) > 0;
        SELECT COUNT(*) INTO invalid_arrays FROM test_results 
        WHERE luscher_choices IS NOT NULL 
        AND NOT (luscher_choices = '{}' OR array_length(luscher_choices, 1) > 0);
        
        RAISE NOTICE 'После миграции:';
        RAISE NOTICE 'Всего записей: %', array_count;
        RAISE NOTICE 'Пустых массивов: %', empty_arrays;
        RAISE NOTICE 'Непустых массивов: %', non_empty_arrays;
        RAISE NOTICE 'Некорректных массивов: %', invalid_arrays;
      END $$;
    SQL
  end
  
  def down
    # 1. Удаляем индексы
    if index_exists?(:test_results, :luscher_choices)
      remove_index :test_results, column: :luscher_choices
    end
    
    if index_exists?(:test_results, :index_test_results_on_user_and_test_and_completed)
      remove_index :test_results, name: 'index_test_results_on_user_and_test_and_completed'
    end
    
    if index_exists?(:test_results, :index_test_results_on_luscher_test_null_completed)
      remove_index :test_results, name: 'index_test_results_on_luscher_test_null_completed'
    end
    
    # 2. Создаем временный столбец text
    add_column :test_results, :luscher_choices_text, :text
    
    # 3. Конвертируем массивы обратно в строки
    execute <<~SQL
      UPDATE test_results 
      SET luscher_choices_text = 
        CASE 
          WHEN luscher_choices = '{}' OR luscher_choices IS NULL THEN ''
          ELSE array_to_string(luscher_choices, ',')
        END;
    SQL
    
    # 4. Удаляем старый столбец массива
    remove_column :test_results, :luscher_choices
    
    # 5. Переименовываем временный столбец
    rename_column :test_results, :luscher_choices_text, :luscher_choices
    
    # 6. Удаляем комментарий
    execute "COMMENT ON COLUMN test_results.luscher_choices IS '';"
  end
end