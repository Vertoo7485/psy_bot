# app/services/telegram/handlers/callback_handler_factory.rb
module Telegram
  module Handlers
    class CallbackHandlerFactory
      # Карта сопоставления callback_data с обработчиками
      HANDLERS_MAP = {
        # Главное меню и общие действия
        'back_to_main_menu' => 'MainMenuHandler',
        'resume_session' => 'ResumeSessionHandler',
        'start_fresh' => 'StartFreshHandler',
        'help' => 'HelpHandler',
        
        # Тесты
        'show_test_categories' => 'TestManagerHandler',
        /^prepare_(anxiety|depression|eq|luscher)_test$/ => 'TestPreparationHandler',
        /^start_(anxiety|depression|eq)_test$/ => 'TestStartHandler',
        'start_luscher_test' => 'LuscherTestStartHandler',
        'show_luscher_interpretation' => 'LuscherInterpretationHandler',
        /^luscher_color_([a-z_]+)_(\d+)$/ => 'LuscherColorHandler',
        /^answer_(\d+)_(\d+)_(\d+)$/ => 'QuizAnswerHandler',
        /^self_help_start_(\w+)_test$/ => 'SelfHelpTestHandler',
        
        # Дневник эмоций
        'start_emotion_diary' => 'EmotionDiaryStartHandler',
        'new_emotion_diary_entry' => 'EmotionDiaryNewEntryHandler',
        'show_emotion_diary_entries' => 'EmotionDiaryShowHandler',
        'show_all_emotion_diaries' => 'EmotionDiaryShowAllHandler',
        
        # Программа самопомощи - общие
        'start_self_help_program' => 'SelfHelpProgramStartHandler',
        'start_self_help_program_tests' => 'SelfHelpTestsStartHandler',
        'restart_self_help_program' => 'RestartProgramHandler',
        'progress' => 'GeneralHandlers::ProgressHandler',
        
        # Ответы да/нет
        'yes' => 'YesResponseHandler',
        'no' => 'NoResponseHandler',
        
        # Завершение тестов (для программы)
        'test_completed_depression' => 'TestCompletedHandler',
        'start_anxiety_test_from_sequence' => 'AnxietyTestSequenceHandler',
        'test_completed_anxiety' => 'TestCompletedHandler',
        'no_anxiety_test_sequence' => 'NoAnxietyTestHandler',
        
        # Дни программы - запуск
        'start_day_1_content' => 'SelfHelpHandlers::DayHandlers::Day1Handler',
        'start_day_1_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day1Handler',
        'continue_day_1_content' => 'SelfHelpHandlers::DayHandlers::Day1Handler',
        'day_1_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day1Handler',
        /^day_1_/ => 'SelfHelpHandlers::DayHandlers::Day1Handler', # Все остальные кнопки дня 1
        'start_day_2_content' => 'SelfHelpHandlers::DayHandlers::Day2Handler',
        'start_day_2_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day2Handler',
        'continue_day_2_content' => 'SelfHelpHandlers::DayHandlers::Day2Handler',
        /^day_2_/ => 'SelfHelpHandlers::DayHandlers::Day2Handler',
        'start_day_3_content' => 'SelfHelpHandlers::DayHandlers::Day3Handler',
        'start_day_3_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day3Handler',
        'continue_day_3_content' => 'SelfHelpHandlers::DayHandlers::Day3Handler',
        /^day_3_/ => 'SelfHelpHandlers::DayHandlers::Day3Handler',
        'start_day_4_content' => 'SelfHelpHandlers::DayHandlers::Day4Handler',
        'start_day_4_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day4Handler',
        'continue_day_4_content' => 'SelfHelpHandlers::DayHandlers::Day4Handler',
        /^day_4_/ => 'SelfHelpHandlers::DayHandlers::Day4Handler',
        'start_day_5_content' => 'SelfHelpHandlers::DayHandlers::Day5Handler',
        'start_day_5_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day5Handler',
        'continue_day_5_content' => 'SelfHelpHandlers::DayHandlers::Day5Handler',
        'day_5_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day5Handler',
        /^day_5_/ => 'SelfHelpHandlers::DayHandlers::Day5Handler',
        'start_day_6_content' => 'SelfHelpHandlers::DayHandlers::Day6Handler',
        'start_day_6_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day6Handler',
        'continue_day_6_content' => 'SelfHelpHandlers::DayHandlers::Day6Handler',
        /^day_6_/ => 'SelfHelpHandlers::DayHandlers::Day6Handler',
        'start_day_7_content' => 'SelfHelpHandlers::DayHandlers::Day7Handler',
        'start_day_7_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day7Handler',
        'continue_day_7_content' => 'SelfHelpHandlers::DayHandlers::Day7Handler',
        /^day_7_/ => 'SelfHelpHandlers::DayHandlers::Day7Handler',
        'start_day_8_content' => 'SelfHelpHandlers::DayHandlers::Day8Handler',
        'start_day_8_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day8Handler',
        'continue_day_8_content' => 'SelfHelpHandlers::DayHandlers::Day8Handler',
        /^day_8_/ => 'SelfHelpHandlers::DayHandlers::Day8Handler',
        'start_day_9_content' => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        'start_day_9_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        'continue_day_9_content' => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        'day_9_enter_thought' => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        'day_9_show_current' => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        'show_all_anxious_thoughts' => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        'complete_day_9' => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        /^day_9_/ => 'SelfHelpHandlers::DayHandlers::Day9Handler',
        'start_day_10_content' => 'SelfHelpHandlers::DayHandlers::Day10Handler',
        'start_day_10_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day10Handler',
        'continue_day_10_content' => 'SelfHelpHandlers::DayHandlers::Day10Handler',
        'day_10_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day10Handler',
        'day_10_viewed_entries' => 'SelfHelpHandlers::DayHandlers::Day10Handler',
        /^day_10_/ => 'SelfHelpHandlers::DayHandlers::Day10Handler',
        'start_day_11_content' => 'SelfHelpHandlers::DayHandlers::Day11Handler',
        'start_day_11_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day11Handler',
        'continue_day_11_content' => 'SelfHelpHandlers::DayHandlers::Day11Handler',
        'start_grounding_exercise' => 'SelfHelpHandlers::DayHandlers::Day11Handler',
        'grounding_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day11Handler',
        /^day_11_/ => 'SelfHelpHandlers::DayHandlers::Day11Handler',
        'start_day_12_content' => 'SelfHelpHandlers::DayHandlers::Day12Handler',
        'start_day_12_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day12Handler',
        'continue_day_12_content' => 'SelfHelpHandlers::DayHandlers::Day12Handler',
        /^day_12_/ => 'SelfHelpHandlers::DayHandlers::Day12Handler',
        'start_day_13_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day13Handler',
        'start_procrastination_exercise' => 'SelfHelpHandlers::DayHandlers::Day13Handler',
        'continue_day_13_content' => 'SelfHelpHandlers::DayHandlers::Day13Handler',
        'procrastination_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day13Handler',
        /^day_13_/ => 'SelfHelpHandlers::DayHandlers::Day13Handler',
        'start_day_14_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day14Handler',
        'start_two_weeks_reflection' => 'SelfHelpHandlers::DayHandlers::Day14Handler',
        'continue_day_14_content' => 'SelfHelpHandlers::DayHandlers::Day14Handler',
        'reflection_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day14Handler',
        'start_day_14_content' => 'SelfHelpHandlers::DayHandlers::Day14Handler',
        /^day_14_/ => 'SelfHelpHandlers::DayHandlers::Day14Handler',
        'start_day_15_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        'start_day_15_content' => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        'continue_day_15_content' => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        'day_15_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        'kindness_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        'start_kindness_exercise' => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        /^day_15_/ => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        'day_15_start_new_practice' => 'SelfHelpHandlers::DayHandlers::Day15Handler',
        'start_day_16_content' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'start_day_16_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'continue_day_16_content' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'day_16_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'reconnection_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'start_reconnection_exercise' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'view_reconnection_history' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'reconnection_stats' => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        /^day_16_/ => 'SelfHelpHandlers::DayHandlers::Day16Handler',
        'start_day_17_content' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        'start_day_17_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        'continue_day_17_content' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        'start_day_17_exercise' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        'day_17_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        'day_17_complete_exercise' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        'view_compassion_letters' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        'day_17_new_letter' => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        /^compassion_step_/ => 'CompassionStepHandler',
        /^day_17_/ => 'SelfHelpHandlers::DayHandlers::Day17Handler',
        /^start_day_18/ => 'Day18Handler',
        /^start_day_18/ => 'SelfHelpHandlers::DayHandlers::Day18Handler',
        'day_18_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day18Handler',
        /^day_18_feelings_(before|after)_\d+$/ => 'SelfHelpHandlers::DayHandlers::Day18Handler',
        /^day_18_category_/ => 'SelfHelpHandlers::DayHandlers::Day18Handler',
        /^day_18_/ => 'SelfHelpHandlers::DayHandlers::Day18Handler',  # Все остальные кнопки дня 18
        'view_pleasure_activities' => 'SelfHelpHandlers::DayHandlers::Day18Handler',
        'back_to_day_18_menu' => 'SelfHelpHandlers::DayHandlers::Day18Handler',
        /^start_day_19/ => 'SelfHelpHandlers::DayHandlers::Day19Handler',
        /^day_19_/ => 'SelfHelpHandlers::DayHandlers::Day19Handler',
        'view_meditation_tips' => 'SelfHelpHandlers::DayHandlers::Day19Handler',
        'view_meditation_stats' => 'SelfHelpHandlers::DayHandlers::Day19Handler',
        'back_to_day_19_menu' => 'SelfHelpHandlers::DayHandlers::Day19Handler',
        'start_day_20_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'start_day_20_content' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'start_day_20_exercise' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'retry_day_20_exercise' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'continue_day_20_content' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'day_20_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        /^day_20_/ => 'SelfHelpHandlers::DayHandlers::Day20Handler',  # Все остальные кнопки дня 20
        'view_fear_tips' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'view_fear_victories' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'back_to_day_20_menu' => 'SelfHelpHandlers::DayHandlers::Day20Handler',
        'start_day_21_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'start_day_21_content' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'start_day_21_exercise' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'continue_day_21_content' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        /^day_21_/ => 'SelfHelpHandlers::DayHandlers::Day21Handler',  # Все остальные кнопки дня 21
        'view_three_weeks_stats' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'view_three_weeks_reflections' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_show_full_reflection' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_show_recommendations' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_show_stats' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_show_reflections' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_review_techniques' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_personal_plan' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'day_21_complete_exercise' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'back_to_day_21_menu' => 'SelfHelpHandlers::DayHandlers::Day21Handler',
        'start_day_22_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day22Handler',
        'start_day_22_content' => 'SelfHelpHandlers::DayHandlers::Day22Handler',
        'start_day_22_exercise' => 'SelfHelpHandlers::DayHandlers::Day22Handler',
        'continue_day_22_content' => 'SelfHelpHandlers::DayHandlers::Day22Handler',
        'retry_day_22_exercise' => 'SelfHelpHandlers::DayHandlers::Day22Handler',
        'day_22_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day22Handler',
        /^day_22_/ => 'SelfHelpHandlers::DayHandlers::Day22Handler',
        'start_day_23_from_proposal' => 'SelfHelpHandlers::DayHandlers::Day23Handler',
        'start_day_23_content' => 'SelfHelpHandlers::DayHandlers::Day23Handler',
        'start_day_23_exercise' => 'SelfHelpHandlers::DayHandlers::Day23Handler',
        'continue_day_23_content' => 'SelfHelpHandlers::DayHandlers::Day23Handler',
        'retry_day_23_exercise' => 'SelfHelpHandlers::DayHandlers::Day23Handler',
        'day_23_exercise_completed' => 'SelfHelpHandlers::DayHandlers::Day23Handler',
        /^day_23_/ => 'SelfHelpHandlers::DayHandlers::Day23Handler',
        /^start_day_(\d+)_from_proposal$/ => 'DayStartHandler',
        
        # Дни программы - продолжение/завершение
        /^continue_day_(\d+)_content$/ => 'DayContinueHandler',
        /^complete_day_(\d+)$/ => 'DayCompleteHandler',
        /^day_(\d+)_exercise_completed$/ => 'DayExerciseCompleteHandler',
        'start_self_compassion_exercise' => 'DayStartHandler',
        'self_compassion_exercise_completed' => 'DayExerciseCompleteHandler',
        
        # Специфичные действия дней
        /^day_(\d+)_distraction_(music|video|friend|exercise|book)$/ => 'DayDistractionHandler',
        /^day_(\d+)_viewed_entries$/ => 'DayViewedEntriesHandler',
        'view_self_compassion_practices' => 'SelfHelpHandlers::DayHandlers::Day12Handler',
        /^view_my_procrastination_tasks$/ => 'SelfHelpHandlers::DayHandlers::Day13Handler',
        'mark_task_completed' => 'SelfHelpHandlers::DayHandlers::Day13Handler',
        'procrastination_first_step_done' => 'ProcrastinationFirstStepHandler',
        /^start_day_16_/ => 'DayStartHandler',
        /^day_16_exercise_completed$/ => 'DayExerciseCompleteHandler',
        'view_reconnection_history' => 'ReconnectionHistoryHandler',
        /^reconnection_/ => 'ReconnectionHistoryHandler',
        'back_to_day_16_menu' => 'MainMenuHandler',
        /^start_day_17_/ => 'DayStartHandler',
        /^day_17_exercise_completed$/ => 'DayExerciseCompleteHandler',
        /^start_day_24/ => 'DayStartHandler',
        'day_24_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_24_/ => 'Day24Handler',
        /^start_day_25/ => 'DayStartHandler',
        'day_25_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_25_/ => 'Day25Handler',
        /^start_day_26/ => 'DayStartHandler',
        'day_26_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_26_/ => 'Day26Handler',
        /^start_day_27/ => 'DayStartHandler',
        'day_27_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_27_/ => 'Day27Handler',
        /^start_day_28/ => 'DayStartHandler',
        'day_28_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_28_/ => 'Day28Handler',
        /^day_28_select_achievement_(\d+)$/ => 'Day28Handler',
        # Финальное завершение
        'complete_program_final' => 'ProgramCompleteHandler',
      }.freeze
      
      class << self
        # Найти обработчик для callback_data
        def handler_for(callback_data, params)
          handler_class_name = nil
          matches = nil
          
          Rails.logger.info "[CallbackHandlerFactory] Looking for handler for: #{callback_data}"
          
          # Ищем подходящий обработчик
          HANDLERS_MAP.each_with_index do |(pattern, handler_name), index|
            Rails.logger.info "[CallbackHandlerFactory] Checking pattern #{index}: #{pattern.inspect}"
            
            if pattern.is_a?(String)
              if callback_data == pattern
                handler_class_name = handler_name
                Rails.logger.info "[CallbackHandlerFactory] Found string match: #{handler_name}"
                break
              end
            elsif pattern.is_a?(Regexp)
              match = callback_data.match(pattern)
              if match
                handler_class_name = handler_name
                matches = match
                Rails.logger.info "[CallbackHandlerFactory] Found regex match: #{handler_name}"
                break
              end
            end
          end
          
          # Если не нашли обработчик
          if handler_class_name.nil?
            Rails.logger.warn "[CallbackHandlerFactory] No handler found for: #{callback_data}"
            handler_class_name = 'UnknownHandler'
          end
          
          Rails.logger.info "[CallbackHandlerFactory] Selected handler: #{handler_class_name}"
          
          # Получаем класс по имени
          handler_class = get_handler_class(handler_class_name)
          
          # Создаем обработчик
          handler = handler_class.new(*params)
          handler.matches = matches if matches && handler.respond_to?(:matches=)
          handler
        end
        
        private
        
        def get_handler_class(handler_name)
          # Пробуем найти класс в разных namespace
          possible_paths = [
            "Telegram::Handlers::#{handler_name}",
            "Telegram::Handlers::SelfHelpHandlers::DayHandlers::#{handler_name}",
            "Telegram::Handlers::SelfHelpHandlers::#{handler_name}",
            "Telegram::Handlers::GeneralHandlers::#{handler_name}",
            "Telegram::Handlers::TestHandlers::#{handler_name}",
            "Telegram::Handlers::EmotionDiaryHandlers::#{handler_name}"
          ]
          
          possible_paths.each do |class_path|
            begin
              return class_path.constantize
            rescue NameError
              next
            end
          end
          
          # Если не нашли, возвращаем UnknownHandler
          "Telegram::Handlers::UnknownHandler".constantize
        end
      end
    end
  end
end