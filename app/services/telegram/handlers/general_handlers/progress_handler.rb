module Telegram
  module Handlers
    module GeneralHandlers
      class ProgressHandler < BaseHandler
        def process
          progress_message = <<~MARKDOWN
            📊 *Ваш прогресс*
            
            ✅ Завершено дней: #{@user.completed_days.size}/28
            📈 Прогресс: #{@user.progress_percentage}%
            
            #{progress_bar(@user.progress_percentage)}
            
            #{next_day_info}
            
            🏆 Продолжайте в том же духе!
          MARKDOWN
          
          send_message(text: progress_message, parse_mode: 'Markdown')
        end
        
        private
        
        def progress_bar(percentage)
          filled = (percentage / 5).to_i
          empty = 20 - filled
          "[" + "▓" * filled + "░" * empty + "] #{percentage}%"
        end
        
        def next_day_info
          next_day = @user.next_available_day
          
          if @user.completed_days.include?(next_day - 1)
            if @user.enough_time_passed?
              "🎯 Следующий день: День #{next_day} - *доступен сейчас*"
            else
              "⏳ Следующий день: День #{next_day} - доступен через #{@user.formatted_time_until_next_day}"
            end
          else
            "⏳ Следующий день: День #{next_day} - сначала завершите День #{next_day - 1}"
          end
        end
      end
    end
  end
end