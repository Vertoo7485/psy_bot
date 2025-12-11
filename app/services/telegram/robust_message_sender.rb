module Telegram
  class RobustMessageSender
    MAX_RETRIES = 3
    RETRY_DELAY = 2.seconds
    
    def initialize(bot_service, user, chat_id)
      @bot_service = bot_service
      @user = user
      @chat_id = chat_id
    end
    
    # Основной метод отправки с повторными попытками
    def send_with_retry(text:, reply_markup: nil, parse_mode: nil, save_to_queue: true)
      message_data = {
        text: text,
        reply_markup: reply_markup,
        parse_mode: parse_mode,
        timestamp: Time.current
      }
      
      # Пытаемся отправить
      success = attempt_send(message_data)
      
      if success
        # Если успешно, очищаем возможную очередь для этого пользователя
        clear_failed_messages
        return true
      else
        # Если не удалось, сохраняем в очередь
        if save_to_queue
          save_to_message_queue(message_data)
          Rails.logger.warn "Message queued for retry: #{text.truncate(50)}"
        end
        return false
      end
    end
    
    # Отправка медиафайлов (аудио, фото)
    def send_audio_with_retry(audio:, caption: nil)
      max_attempts = 2 # Для файлов меньше попыток
      
      max_attempts.times do |attempt|
        begin
          @bot_service.bot.send_audio(
            chat_id: @chat_id,
            audio: audio,
            caption: caption
          )
          return true
        rescue Telegram::Bot::Error => e
          Rails.logger.error "Audio send attempt #{attempt + 1} failed: #{e.message}"
          sleep(RETRY_DELAY) if attempt < max_attempts - 1
        end
      end
      
      false
    end
    
    # Обработать очередь неотправленных сообщений
    def process_message_queue
      return unless @user.active_session
      
      queue = @user.active_session.message_queue || []
      
      queue.each_with_index do |message_data, index|
        next if message_data['retry_count'].to_i >= MAX_RETRIES
        
        # Пытаемся отправить снова
        success = attempt_send(message_data['message'])
        
        if success
          # Удаляем из очереди
          @user.active_session.remove_from_queue(index)
        else
          # Увеличиваем счетчик попыток
          @user.active_session.increment_retry(index)
          
          # Если слишком много попыток, удаляем
          if message_data['retry_count'].to_i >= MAX_RETRIES
            Rails.logger.error "Message permanently failed after #{MAX_RETRIES} attempts"
            @user.active_session.remove_from_queue(index)
          end
        end
      end
    end
    
    private
    
    # Попытка отправки
    def attempt_send(message_data)
      begin
        Timeout.timeout(10) do # Таймаут 10 секунд
          @bot_service.send_message(
            chat_id: @chat_id,
            text: message_data[:text],
            reply_markup: message_data[:reply_markup],
            parse_mode: message_data[:parse_mode]
          )
        end
        true
      rescue Timeout::Error
        Rails.logger.error "Timeout sending message to #{@chat_id}"
        false
      rescue Telegram::Bot::Error => e
        Rails.logger.error "Telegram API error: #{e.message}"
        false
      rescue => e
        Rails.logger.error "Unexpected error: #{e.message}"
        false
      end
    end
    
    # Сохранить в очередь
    def save_to_message_queue(message_data)
      @user.active_session&.add_to_queue(message_data)
    end
    
    # Очистить проваленные сообщения
    def clear_failed_messages
      @user.active_session&.clear_queue
    end
  end
end