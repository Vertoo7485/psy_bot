#!/usr/bin/env ruby
# Скрипт для миграции данных из SQLite в PostgreSQL

require 'sqlite3'
require 'pg'

puts "=" * 60
puts "МИГРАЦИЯ ДАННЫХ ИЗ SQLITE В POSTGRESQL"
puts "=" * 60

# Конфигурация
SQLITE_DB = 'storage/development.sqlite3'
PG_CONFIG = {
  host: 'localhost',
  port: 5432,
  dbname: 'psy_bot_development',
  user: 'psy_bot_app',
  password: 'secure_password_123'
}

# Проверяем существование SQLite базы
unless File.exist?(SQLITE_DB)
  puts "❌ SQLite база не найдена: #{SQLITE_DB}"
  exit 1
end

begin
  # Подключаемся к SQLite
  puts "📂 Подключаемся к SQLite: #{SQLITE_DB}"
  sqlite = SQLite3::Database.new(SQLITE_DB)
  sqlite.results_as_hash = true
  
  # Подключаемся к PostgreSQL
  puts "🐘 Подключаемся к PostgreSQL: #{PG_CONFIG[:dbname]}"
  pg = PG.connect(PG_CONFIG)
  
  # Получаем список таблиц (исключаем служебные)
  tables = sqlite.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")
  
  puts "📊 Найдено таблиц: #{tables.size}"
  
  # Порядок миграции (важен для внешних ключей)
  migration_order = [
    'users',
    'settings',
    'tests',
    'questions',
    'answer_options',
    'test_results',
    'answers',
    'emotion_diary_entries',
    'gratitude_entries',
    'reflection_entries',
    'anxious_thought_entries',
    'user_sessions',
    'grounding_exercise_entries',
    'self_compassion_practices',
    'procrastination_tasks',
    'reconnection_practices',
    'compassion_letters',
    'pleasure_activities',
    'meditation_sessions'
  ]
  
  total_migrated = 0
  
  migration_order.each do |table_name|
    # Проверяем, существует ли таблица в SQLite
    exists = sqlite.execute("SELECT name FROM sqlite_master WHERE type='table' AND name = ?", table_name)
    next if exists.empty?
    
    puts "\n📋 Таблица: #{table_name}"
    
    # Получаем данные из SQLite
    rows = sqlite.execute("SELECT * FROM #{table_name}")
    
    if rows.empty?
      puts "   Пустая, пропускаем"
      next
    end
    
    puts "   Записей в SQLite: #{rows.size}"
    
    # Для каждой строки
    migrated_count = 0
    rows.each_with_index do |row, index|
      begin
        # Подготавливаем данные для вставки
        columns = row.keys.join(', ')
        placeholders = (1..row.size).map { |i| "$#{i}" }.join(', ')
        values = row.values
        
        # SQL запрос для вставки
        sql = "INSERT INTO #{table_name} (#{columns}) VALUES (#{placeholders}) ON CONFLICT DO NOTHING"
        
        # Выполняем вставку
        pg.exec_params(sql, values)
        migrated_count += 1
        
        # Прогресс для больших таблиц
        if rows.size > 100 && (index % 100 == 0)
          print "   #{index}/#{rows.size}\r"
        end
      rescue PG::Error => e
        puts "   ❌ Ошибка при вставке записи #{index}: #{e.message}"
        # Продолжаем миграцию остальных записей
      end
    end
    
    puts "   Успешно мигрировано: #{migrated_count}/#{rows.size}"
    total_migrated += migrated_count
    
  end
  
  puts "\n" + "=" * 60
  puts "✅ МИГРАЦИЯ ЗАВЕРШЕНА"
  puts "📈 Всего перенесено записей: #{total_migrated}"
  
  # Проверяем результаты
  puts "\n🔍 ПРОВЕРКА РЕЗУЛЬТАТОВ:"
  puts "-" * 40
  
  check_tables = ['users', 'emotion_diary_entries', 'gratitude_entries']
  check_tables.each do |table|
    result = pg.exec("SELECT COUNT(*) FROM #{table}").first
    puts "   #{table}: #{result['count']} записей"
  end
  
rescue => e
  puts "❌ Ошибка: #{e.message}"
  puts e.backtrace.join("\n")
ensure
  sqlite&.close
  pg&.close
  puts "\n✅ Соединения закрыты"
end
