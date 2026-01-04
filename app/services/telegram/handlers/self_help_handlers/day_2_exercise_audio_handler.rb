# app/services/telegram/handlers/self_help_handlers/day_2_exercise_audio_handler.rb
module Telegram
  module Handlers
    class Day2ExerciseAudioHandler < BaseHandler
      def process
        log_info("Starting day 2 exercise audio")
        
        # Просто вызываем deliver_exercise из Day2Service
        require Rails.root.join('app/services/self_help/days/day_2_service')
        
        service = SelfHelp::Days::Day2Service.new(@bot_service, @user, @chat_id)
        service.deliver_exercise
        
        answer_callback_query( "Запускаю медитацию дня 2...")
      end
    end
  end
end