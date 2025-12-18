# app/services/telegram/robust_message_sender.rb
module Telegram
  class RobustMessageSender
    # Константы
    MAX_RETRIES = 3
    RETRY_DELAY = 2.seconds
    MESSAGE_TIMEOUT = 10.seconds
    
    attr_reader :bot_service, :user, :chat_id
    
    def initialize(bot_service, user, chat_id)
      @bot_service = bot_service
      @user = user
      @chat_id = chat_id
    end
    
    # Основной метод отправки с повторными попытками
    def send_with_retry(text:, reply_markup: nil, parse_mode: nil, save_to_queue: true)
      message_data = build_message_data(text, reply_markup, parse_mode)
      
      # Пытаемся отправить сразу
      success = attempt_send(message_data)
      
      if success
        # Если успешно, очищаем возможную очередь для этого пользователя
        clear_failed_messages
        log_success(message_data[:text])
        return true
      else
        # Если не удалось, сохраняем в очередь
        if save_to_queue
          save_to_message_queue(message_data)
          log_queue(message_data[:text])
        end
        return false
      end
    end
    
    # Отправка аудио с повторными попытками
    def send_audio_with_retry(audio:, caption: nil)
      log_debug("Sending audio with caption: #{caption}")
      
      MAX_RETRIES.times do |attempt|
        begin
          @bot_service.bot.send_audio(
            chat_id: @chat_id,
            audio: audio,
            caption: caption
          )
          log_success("audio file")
          return true
        rescue Telegram::Bot::Error => e
          log_audio_error(attempt, e)
          sleep(RETRY_DELAY) if attempt < MAX_RETRIES - 1
        rescue => e
          log_unexpected_error("sending audio", e)
          sleep(RETRY_DELAY) if attempt < MAX_RETRIES - 1
        end
      end
      
      false
    end
    
    # Отправка фото с повторными попытками
    def send_photo_with_retry(photo:, caption: nil)
      log_debug("Sending photo with caption: #{caption}")
      
      MAX_RETRIES.times do |attempt|
        begin
          @bot_service.bot.send_photo(
            chat_id: @chat_id,
            photo: photo,
            caption: caption
          )
          log_success("photo")
          return true
        rescue Telegram::Bot::Error => e
          log_photo_error(attempt, e)
          sleep(RETRY_DELAY) if attempt < MAX_RETRIES - 1
        rescue => e
          log_unexpected_error("sending photo", e)
          sleep(RETRY_DELAY) if attempt < MAX_RETRIES - 1
        end
      end
      
      false
    end
    
    # Обработка очереди неотправленных сообщений
    def process_message_queue
      return unless @user.active_session
      
      queue = message_queue_array
      
      queue.each_with_index do |message_data, index|
        break unless process_queue_item(message_data, index)
      end
    end
    
    # Получение количества сообщений в очереди
    def queue_size
      return 0 unless @user.active_session
      
      message_queue_array.size
    end
    
    # Очистка очереди
    def clear_queue
      @user.active_session&.clear_queue
      log_info("Message queue cleared")
    end
    
    private
    
    # Построение данных сообщения
    def build_message_data(text, reply_markup, parse_mode)
      {
        text: text,
        reply_markup: reply_markup,
        parse_mode: parse_mode,
        timestamp: Time.current,
        attempts: 0
      }
    end
    
    # Попытка отправки сообщения
    def attempt_send(message_data)
      begin
        Timeout.timeout(MESSAGE_TIMEOUT) do
          @bot_service.send_message(
            chat_id: @chat_id,
            text: message_data[:text],
            reply_markup: message_data[:reply_markup],
            parse_mode: message_data[:parse_mode]
          )
        end
        true
      rescue Timeout::Error
        log_timeout_error
        false
      rescue Telegram::Bot::Error => e
        log_telegram_error(e)
        false
      rescue => e
        log_unexpected_error("sending message", e)
        false
      end
    end
    
    # Сохранение в очередь
    def save_to_message_queue(message_data)
      @user.active_session&.add_to_queue(message_data)
    end
    
    # Получение очереди сообщений как массива
    def message_queue_array
      @user.active_session&.message_queue || []
    end
    
    # Обработка элемента очереди
    def process_queue_item(message_data, index)
      return false if message_data['retry_count'].to_i >= MAX_RETRIES
      
      # Пытаемся отправить снова
      success = attempt_send(message_data['message'])
      
      if success
        # Удаляем из очереди при успешной отправке
        @user.active_session&.remove_from_queue(index)
        log_queue_success(message_data['message'][:text], index)
        true
      else
        # Увеличиваем счетчик попыток
        @user.active_session&.increment_retry(index)
        
        # Если слишком много попыток, удаляем
        if message_data['retry_count'].to_i >= MAX_RETRIES
          log_queue_failure(message_data['message'][:text], index)
          @user.active_session&.remove_from_queue(index)
        end
        
        false
      end
    end
    
    # Очистка проваленных сообщений
    def clear_failed_messages
      @user.active_session&.clear_queue
    end
    
    # Логирование успешной отправки
    def log_success(content_description)
      Rails.logger.debug "[RobustMessageSender] Successfully sent: #{content_description.truncate(50)}"
    end
    
    # Логирование помещения в очередь
    def log_queue(content)
      Rails.logger.warn "[RobustMessageSender] Message queued for retry: #{content.truncate(50)}"
    end
    
    # Логирование успеха из очереди
    def log_queue_success(content, index)
      Rails.logger.info "[RobustMessageSender] Successfully sent queued message #{index}: #{content.truncate(50)}"
    end
    
    # Логирование провала из очереди
    def log_queue_failure(content, index)
      Rails.logger.error "[RobustMessageSender] Permanently failed to send queued message #{index}: #{content.truncate(50)}"
    end
    
    # Логирование таймаута
    def log_timeout_error
      Rails.logger.error "[RobustMessageSender] Timeout sending message to #{@chat_id}"
    end
    
    # Логирование ошибки Telegram
    def log_telegram_error(error)
      Rails.logger.error "[RobustMessageSender] Telegram API error: #{error.message}"
    end
    
    # Логирование ошибки аудио
    def log_audio_error(attempt, error)
      Rails.logger.error "[RobustMessageSender] Audio send attempt #{attempt + 1} failed: #{error.message}"
    end
    
    # Логирование ошибки фото
    def log_photo_error(attempt, error)
      Rails.logger.error "[RobustMessageSender] Photo send attempt #{attempt + 1} failed: #{error.message}"
    end
    
    # Логирование неожиданной ошибки
    def log_unexpected_error(action, error)
      Rails.logger.error "[RobustMessageSender] Unexpected error #{action}: #{error.message}"
    end
    
    # Логирование информации
    def log_info(message)
      Rails.logger.info "[RobustMessageSender] #{message} - User: #{@user.telegram_id}"
    end
    
    # Логирование отладки
    def log_debug(message)
      Rails.logger.debug "[RobustMessageSender] #{message}" if Rails.env.development?
    end
  end
end