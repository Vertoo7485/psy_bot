module Telegram
  module Handlers
    module SelfHelpHandlers
      class ReconnectionHistoryHandler < BaseHandler
        def process
          case @callback_data
          when 'view_reconnection_history'
            show_history
          when 'reconnection_stats'
            show_stats
          when 'reconnection_general_stats'
            show_general_stats
          when 'reconnection_monthly_stats'
            show_monthly_stats
          when 'reconnection_format_stats'
            show_format_stats
          when 'reconnection_success_stats'
            show_success_stats
          when 'reconnection_by_date'
            show_by_date
          when 'reconnection_calls_only'
            show_calls_only
          when 'reconnection_messages_only'
            show_messages_only
          when 'reconnection_best'
            show_best_practices
          else
            show_history
          end
        end

        def show_general_stats
  service = SelfHelp::Days::Day16Service.new(@bot_service, @user, @chat_id)
  service.show_reconnection_stats
end

def show_monthly_stats
  practices = @user.reconnection_practices
  
  if practices.empty?
    send_message(text: "Нет данных для статистики по месяцам.")
    return
  end
  
  # Группируем по месяцам
  by_month = practices.group_by { |p| p.entry_date.beginning_of_month }
  
  message = "📅 Статистика по месяцам:\n\n"
  
  by_month.sort.reverse_each do |month, month_practices|
    message += "#{month.strftime('%B %Y')}: #{month_practices.count} практик\n"
  end
  
  send_message(text: message, parse_mode: 'Markdown')
end

def show_format_stats
  practices = @user.reconnection_practices
  
  if practices.empty?
    send_message(text: "Нет данных по форматам общения.")
    return
  end
  
  # Группируем по форматам
  by_format = practices.group_by(&:communication_format)
  
  message = "📊 Статистика по форматам общения:\n\n"
  
  by_format.each do |format, format_practices|
    emoji = case format
            when 'звонок' then '📞'
            when 'сообщение' then '💬'
            when 'письмо' then '✉️'
            else '📱'
            end
    
    percentage = (format_practices.count.to_f / practices.count * 100).round(1)
    message += "#{emoji} #{format.capitalize}: #{format_practices.count} (#{percentage}%)\n"
  end
  
  send_message(text: message, parse_mode: 'Markdown')
end

def show_success_stats
  practices = @user.reconnection_practices
  
  if practices.empty?
    send_message(text: "Нет данных по успешности.")
    return
  end
  
  # Группируем по уровню успеха
  beginner = practices.select { |p| p.success_score <= 1 }.count
  good = practices.select { |p| p.success_score.between?(2, 3) }.count
  excellent = practices.select { |p| p.success_score == 4 }.count
  
  message = "⭐ Статистика успешности:\n\n"
  message += "🟡 Начальный уровень (1/4): #{beginner} практик\n"
  message += "🟢 Хороший уровень (2-3/4): #{good} практик\n"
  message += "🔴 Отличный уровень (4/4): #{excellent} практик\n"
  
  total = practices.count
  if total > 0
    success_rate = ((good + excellent).to_f / total * 100).round(1)
    message += "\n📈 Общая успешность: #{success_rate}%"
  end
  
  send_message(text: message, parse_mode: 'Markdown')
end

def show_by_date
  practices = @user.reconnection_practices.order(entry_date: :desc)
  
  if practices.empty?
    send_message(text: "Нет записей для показа по дате.")
    return
  end
  
  message = "📅 Записи по дате (новые сначала):\n\n"
  
  practices.each do |practice|
    emoji = case practice.communication_format
            when 'звонок' then '📞'
            when 'сообщение' then '💬'
            when 'письмо' then '✉️'
            else '📱'
            end
    
    message += "• #{practice.entry_date.strftime('%d.%m.%Y')}: #{emoji} #{practice.reconnected_person}\n"
  end
  
  send_message(text: message, parse_mode: 'Markdown')
end

def show_calls_only
  show_filtered_practices('звонок', '📞 Только звонки')
end

def show_messages_only
  show_filtered_practices('сообщение', '💬 Только сообщения')
end

def show_filtered_practices(format, title)
  practices = @user.reconnection_practices.by_format(format).order(created_at: :desc)
  
  if practices.empty?
    send_message(text: "Нет записей с форматом '#{format}'.")
    return
  end
  
  send_message(text: "#{title}:\n", parse_mode: 'Markdown')
  
  practices.each_with_index do |practice, index|
    message = "#{index + 1}. *#{practice.reconnected_person}*\n"
    message += "   📅 #{practice.entry_date.strftime('%d.%m.%Y')}\n"
    
    if practice.reflection_text.present?
      message += "   💭 #{practice.reflection_text.truncate(60)}\n"
    end
    
    send_message(text: message, parse_mode: 'Markdown')
  end
end
        
        private
        
        def show_history
          service = SelfHelp::Days::Day16Service.new(@bot_service, @user, @chat_id)
          service.show_previous_practices
        end
        
        def show_stats
          service = SelfHelp::Days::Day16Service.new(@bot_service, @user, @chat_id)
          service.show_reconnection_stats
        end
        
        # ... другие методы
        
        def show_best_practices
          best_practices = @user.reconnection_practices
                               .sort_by { |p| -p.success_score }
                               .first(3)
          
          if best_practices.empty?
            send_message(text: "У вас пока нет сохраненных практик.")
            return
          end
          
          send_message(text: "🏆 Лучшие практики восстановления связей", parse_mode: 'Markdown')
          
          best_practices.each_with_index do |practice, index|
            message = <<~MARKDOWN
              🥇 Практика ##{index + 1} (оценка: #{practice.success_score}/4)

              #{practice.format_emoji} #{practice.reconnected_person}
              📅 #{practice.entry_date.strftime('%d.%m.%Y')}
              💭 #{practice.reflection_text&.truncate(80) || 'Рефлексия не указана'}
              ──────────────────────
            MARKDOWN
            
            send_message(text: message, parse_mode: 'Markdown')
          end
        end
      end
    end
  end
end