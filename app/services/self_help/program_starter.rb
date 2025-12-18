# app/services/self_help/program_starter.rb
module SelfHelp
  class ProgramStarter
    include TelegramMarkupHelper
    
    attr_reader :bot_service, :user, :chat_id
    
    def initialize(bot_service, user, chat_id)
      @bot_service = bot_service
      @user = user
      @chat_id = chat_id
    end
    
    def start
      log_info("Starting program initiation")
      
      # Если пользователь уже в программе, предлагаем восстановить
      if user_has_incomplete_program?
        return offer_resume
      end
      
      # Начинаем новую программу
      start_new_program
    end
    
    # Предложение восстановить сессию
    def offer_resume
      current_state = @user.self_help_state
      log_info("Offering resume from state: #{current_state}")
      
      message = <<~TEXT
        🔍 Найдена незавершенная программа самопомощи.

        Вы хотите продолжить с того места, где остановились?
      TEXT
      
      markup = {
        inline_keyboard: [
          [{ text: 'Да, продолжить', callback_data: 'resume_session' }],
          [{ text: 'Нет, начать заново', callback_data: 'restart_self_help_program' }]
        ]
      }.to_json
      
      @bot_service.send_message(
        chat_id: @chat_id,
        text: message,
        reply_markup: markup
      )
    end
    
    private
    
    # Проверка наличия незавершенной программы
    def user_has_incomplete_program?
      @user.self_help_state.present? && 
      @user.self_help_state != 'program_started' &&
      !@user.self_help_state.start_with?('completed')
    end
    
    # Запуск новой программы
    def start_new_program
      @user.set_self_help_step('program_started')
      
      message = <<~MARKDOWN
        🌟 *Начало программы самопомощи* 🌟

        Привет! Я ваш бот для психологической поддержки.

        Мы начнем с прохождения нескольких тестов, чтобы лучше понять ваше текущее состояние. Это поможет нам адаптировать программу под ваши потребности.

        **Важно:**
        • Все данные анонимны
        • Результаты видны только вам
        • Вы можете остановиться в любой момент
      MARKDOWN
      
      @bot_service.send_message(
        chat_id: @chat_id,
        text: message,
        parse_mode: 'Markdown',
        reply_markup: TelegramMarkupHelper.self_help_intro_markup
      )
    end
    
    # Логирование
    def log_info(message)
      Rails.logger.info "[ProgramStarter] #{message} - User: #{@user.telegram_id}"
    end
    
    def log_error(message, error = nil)
      Rails.logger.error "[ProgramStarter] #{message} - User: #{@user.telegram_id}"
      Rails.logger.error error.message if error
    end
  end
end