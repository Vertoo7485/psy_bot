# lib/tasks/dev.rake
namespace :dev do
  desc "Force complete a day with realistic time simulation"
  task :complete_day, [:telegram_id, :day_number] => :environment do |t, args|
    telegram_id = args[:telegram_id].to_i
    day_number = args[:day_number].to_i
    
    user = User.find_by(telegram_id: telegram_id)
    
    unless user
      puts "❌ User not found with telegram_id: #{telegram_id}"
      exit 1
    end
    
    puts "\n" + "="*60
    puts "🎯 FORCE COMPLETE DAY #{day_number}"
    puts "="*60
    puts "👤 User: #{user.first_name} #{user.last_name} (@#{user.username})"
    puts "📊 Current completed days: #{user.completed_days || []}"
    
    # 1. Проверяем, не завершен ли уже этот день
    if user.completed_days&.include?(day_number)
      puts "⚠️  Day #{day_number} already completed!"
      puts "Force anyway? (y/N)"
      unless STDIN.gets.strip.downcase == 'y'
        puts "❌ Cancelled"
        exit 0
      end
    end
    
    # 2. Проверяем предыдущие дни
    if day_number > 1
      (1..day_number-1).each do |prev_day|
        unless user.completed_days&.include?(prev_day)
          puts "⚠️  Day #{prev_day} not completed! Completing it first..."
          
          # Завершаем предыдущий день
          user.transaction do
            user.completed_days ||= []
            user.completed_days << prev_day unless user.completed_days.include?(prev_day)
            user.current_day_started_at = nil
            user.last_day_completed_at = 13.hours.ago - (day_number - prev_day).days
            user.save!
          end
          
          puts "✅ Day #{prev_day} completed retroactively"
        end
      end
    end
    
    # 3. Симулируем реальное прохождение времени
    puts "\n🕐 Simulating realistic time passage..."
    
    # Рассчитываем время: каждый день завершался с интервалом 13 часов
    time_ago = 13.hours.ago
    
    user.transaction do
      # Добавляем текущий день
      user.completed_days ||= []
      user.completed_days << day_number unless user.completed_days.include?(day_number)
      
      # Устанавливаем временные метки
      user.current_day_started_at = nil  # Нет активного дня
      user.last_day_completed_at = time_ago
      user.self_help_program_step = "awaiting_day_#{day_number + 1}_start"
      
      # Очищаем данные дня, если они есть
      user.clear_day_data(day_number)
      
      user.save!
    end
    
    puts "\n✅ SUCCESS!"
    puts "📊 New completed days: #{user.completed_days.sort}"
    puts "🕐 Last day completed at: #{user.last_day_completed_at}"
    puts "📝 Next step: #{user.self_help_program_step}"
    
    # 4. Проверяем доступность следующего дня
    puts "\n🔍 VALIDATION:"
    
    if day_number < 28
      next_day = day_number + 1
      can_start = user.can_start_day?(next_day)
      
      if can_start == true
        puts "✅ Day #{next_day} is AVAILABLE for start"
      else
        puts "❌ Day #{next_day} is NOT available:"
        if can_start.is_a?(Array)
          can_start.each { |error| puts "   - #{error}" }
        else
          puts "   - #{can_start}"
        end
        
        # Подсказка по исправлению
        puts "\n💡 DEBUG INFO:"
        puts "   completed_days: #{user.completed_days}"
        puts "   current_day_started_at: #{user.current_day_started_at}"
        puts "   last_day_completed_at: #{user.last_day_completed_at}"
        puts "   hours_since_last: #{((Time.current - user.last_day_completed_at) / 3600).round(2)}h" if user.last_day_completed_at
      end
    else
      puts "🎉 All 28 days completed!"
    end
    
    puts "\n🚀 Try in bot: /progress or start day #{day_number + 1}"
  end
end