require_relative 'production'

Rails.application.configure do
  # Включаем максимальное логирование
  config.log_level = :debug
  
  # Логируем ВСЕ SQL запросы
  config.active_record.verbose_query_logs = true
  
  # Цветные логи
  config.colorize_logging = true
  
  # Логируем в STDOUT для systemd
  config.logger = ActiveSupport::Logger.new(STDOUT)
  config.logger.formatter = ::Logger::Formatter.new
  
  # Логируем параметры запросов
  config.filter_parameters = []  # НЕ фильтруем параметры (временно для отладки)
  
  # Логируем все
  config.log_tags = [:request_id]
  
  puts "✅ DEBUG режим активирован!"
end
