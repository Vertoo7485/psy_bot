# config/initializers/load_all_handlers.rb

puts "=== Loading all handlers ===" if Rails.env.development?

# Загружаем base_handler
require Rails.root.join('app/services/telegram/handlers/base_handler')

# Загружаем все остальные handlers
handlers_dir = Rails.root.join('app/services/telegram/handlers')
Dir.glob(handlers_dir.join('**', '*.rb')).sort.each do |file|
  next if file.include?('callback_handler_factory.rb')
  
  begin
    require file
    puts "  ✓ #{file.gsub(handlers_dir.to_s + '/', '')}" if Rails.env.development?
  rescue => e
    puts "  ✗ #{file.gsub(handlers_dir.to_s + '/', '')}: #{e.message}" if Rails.env.development?
  end
end

puts "=== All handlers loaded ===" if Rails.env.development?