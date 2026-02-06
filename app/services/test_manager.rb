# app/services/test_manager.rb
class TestManager
  include TelegramMarkupHelper
  
  # Константы с сообщениями подготовки к тестам
  TEST_PREP_MESSAGES = {
    anxiety: {
      name: "Тест Тревожности",
      description: "Тест Тревожности поможет вам оценить уровень тревожности. Ответьте на вопросы, чтобы получить результат.",
      duration: "Примерное время прохождения: 5-10 минут."
    },
    depression: {
      name: "Тест Депрессии (PHQ-9)",
      description: "Тест Депрессии (PHQ-9) - это короткий опросник, который поможет оценить ваше состояние и выявить возможные признаки депрессии.",
      duration: "Примерное время прохождения: 3-5 минут."
    },
    eq: {
      name: "Тест EQ (Эмоциональный Интеллект)",
      description: "Тест EQ (Эмоциональный Интеллект) поможет вам оценить вашу способность понимать и управлять своими эмоциями, а также понимать эмоции других людей.",
      duration: "Примерное время прохождения: 7-12 минут."
    },
    luscher: {
      name: "8-ми цветовой тест Люшера",
      description: "8-ми цветовой тест Люшера поможет вам оценить ваше психоэмоциональное состояние. Тест состоит из выбора цветов в порядке предпочтения.",
      duration: "Примерное время прохождения: 3-5 минут."
    }
  }.freeze
  
  attr_reader :bot_service, :user, :chat_id
  
  def initialize(bot_service, user, chat_id)
    @bot_service = bot_service
    @user = user
    @chat_id = chat_id
  end
  
  # Показать список категорий тестов
  def show_categories
    log_info("Showing test categories")
    
    message = "📋 *Выберите тест, который вы хотите пройти:*\n\n"
    
    # Добавляем описание каждого доступного теста
    available_tests.each do |test|
      prep_info = TEST_PREP_MESSAGES[test[:type].to_sym]
      if prep_info
        message += "• *#{prep_info[:name]}*\n"
        message += "  #{prep_info[:description]}\n"
        message += "  ⏱ #{prep_info[:duration]}\n\n"
      end
    end
    
    send_message(
      text: message,
      parse_mode: 'Markdown',
      reply_markup: TelegramMarkupHelper.test_categories_markup
    )
  end
  
  # Подготовка к началу конкретного теста
  def prepare_test(test_type, in_program_context: false)
    prep_info = TEST_PREP_MESSAGES[test_type.to_sym]
    
    unless prep_info
      log_error("Test preparation info not found for: #{test_type}")
      send_error_message("Извините, информация по этому тесту не найдена.")
      return false
    end
    
    message = <<~MARKDOWN
      *#{prep_info[:name]}*

      #{prep_info[:description]}

      #{prep_info[:duration]}
    MARKDOWN
    
    # Разные callback_data для разных контекстов
    if in_program_context
      callback_data = test_type == 'luscher' ? 'self_help_start_luscher_test' : "self_help_start_#{test_type}_test"
    else
      callback_data = test_type == 'luscher' ? 'start_luscher_test' : "start_#{test_type}_test"
    end
    
    markup = {
      inline_keyboard: [
        [{ text: 'Начать тест', callback_data: callback_data }],
        [{ text: 'Назад к списку тестов', callback_data: 'show_test_categories' }]
      ]
    }.to_json
    
    send_message(
      text: message,
      parse_mode: 'Markdown',
      reply_markup: markup
    )
    
    true
  end
  
  # Запуск теста
  def start_test(test_type)
    case test_type.to_sym
    when :luscher
      start_luscher_test
    when :anxiety, :depression, :eq
      start_standard_test(test_type)
    else
      log_error("Unknown test type: #{test_type}")
      send_error_message("Неизвестный тип теста.")
      false
    end
  end
  
  private
  
  # Получение списка доступных тестов
  def available_tests
    tests = []
    
    Test.all.each do |test|
      test_type = test.test_type.try(:to_sym) || :standard
      
      case test_type
      when :standard
        case test.name
        when "Тест Тревожности"
          tests << { type: :anxiety, name: test.name }
        when "Тест Депрессии (PHQ-9)"
          tests << { type: :depression, name: test.name }
        when "Тест EQ (Эмоциональный Интеллект)"
          tests << { type: :eq, name: test.name }
        end
      when :luscher
        tests << { type: :luscher, name: test.name }
      end
    end
    
    tests
  end
  
  # Запуск стандартного теста
  def start_standard_test(test_type)
    log_info("Starting standard test: #{test_type}")
    
    runner = QuizRunner.new(@bot_service, @user, @chat_id)
    runner.start_quiz(test_type)
    
    true
  rescue => e
    log_error("Failed to start standard test: #{test_type}", e)
    send_error_message("Ошибка при запуске теста. Пожалуйста, попробуйте позже.")
    false
  end
  
  # Запуск теста Люшера
  def start_luscher_test
    log_info("Starting Luscher test")
    
    service = LuscherTestService.new(@bot_service, @user, @chat_id)
    service.start_test
    
    true
  rescue => e
    log_error("Failed to start Luscher test", e)
    send_error_message("Ошибка при запуске теста Люшера. Пожалуйста, попробуйте позже.")
    false
  end
  
  # Отправка сообщения
  def send_message(text:, reply_markup: nil, parse_mode: nil)
    @bot_service.send_message(
      chat_id: @chat_id,
      text: text,
      reply_markup: reply_markup,
      parse_mode: parse_mode
    )
  end
  
  # Отправка сообщения об ошибке
  def send_error_message(text)
    send_message(text: text)
  end
  
  # Логирование
  def log_info(message)
    Rails.logger.info "[TestManager] #{message} - User: #{@user.telegram_id}"
  end
  
  def log_error(message, error = nil)
    Rails.logger.error "[TestManager] #{message} - User: #{@user.telegram_id}"
    Rails.logger.error error.message if error
    Rails.logger.error error.backtrace.join("\n") if error.respond_to?(:backtrace)
  end
end