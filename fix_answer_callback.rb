# Скрипт для исправления вызовов answer_callback_query
require 'fileutils'

def fix_file(file_path)
  content = File.read(file_path)
  
  # Заменяем все answer_callback_query("текст") на answer_callback_query(text: "текст")
  fixed_content = content.gsub(/answer_callback_query\("([^"]+)"\)/) do |match|
    text = $1
    "answer_callback_query(text: \"#{text}\")"
  end
  
  if content != fixed_content
    puts "Исправляю #{file_path}"
    File.write(file_path, fixed_content)
    return true
  end
  
  false
end

# Находим все файлы
files = Dir.glob("app/services/telegram/handlers/**/*.rb")
fixed_count = 0

files.each do |file|
  fixed_count += 1 if fix_file(file)
end

puts "Исправлено файлов: #{fixed_count}"
