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
        /^start_day_(\d+)_from_proposal$/ => 'DayStartHandler',
        /^start_day_(\d+)_content$/ => 'DayStartHandler',
        /^start_day_(\d+)_exercise$/ => 'DayStartHandler',
        'day_8_stopped_thought_first_try' => 'Day8Handler',
        /^day_8_distraction_(music|video|friend|exercise|book)$/ => 'Day8Handler',
        'day_8_exercise_completed' => 'Day8Handler',
        
        # Дни программы - продолжение/завершение
        /^continue_day_(\d+)_content$/ => 'DayContinueHandler',
        /^complete_day_(\d+)$/ => 'DayCompleteHandler',
        /^day_(\d+)_exercise_completed$/ => 'DayExerciseCompleteHandler',
        'start_grounding_exercise' => 'DayStartHandler',
        'start_self_compassion_exercise' => 'DayStartHandler',
        'grounding_exercise_completed' => 'DayExerciseCompleteHandler',
        'self_compassion_exercise_completed' => 'DayExerciseCompleteHandler',
        'start_procrastination_exercise' => 'DayStartHandler',
        'procrastination_exercise_completed' => 'DayExerciseCompleteHandler',
        
        # Специфичные действия дней
        'start_day_2_exercise_audio' => 'Day2ExerciseAudioHandler',
        /^day_(\d+)_enter_gratitude$/ => 'DayGratitudeHandler',
        'show_gratitude_entries' => 'ShowGratitudeEntriesHandler',
        'back_to_day_3_menu' => 'Day3MenuHandler',
        'day_9_enter_thought' => 'Day9Handler',
        'day_9_show_current' => 'Day9Handler',
        'show_all_anxious_thoughts' => 'Day9Handler',
        'complete_day_9' => 'Day9Handler',
        /^day_(\d+)_distraction_(music|video|friend|exercise|book)$/ => 'DayDistractionHandler',
        /^day_(\d+)_viewed_entries$/ => 'DayViewedEntriesHandler',
        /^view_self_compassion_practices$/ => 'DaySelfCompassionHandler',
        /^view_my_procrastination_tasks$/ => 'DayProcrastinationHandler',
        'mark_task_completed' => 'MarkTaskCompletedHandler',
        'procrastination_first_step_done' => 'ProcrastinationFirstStepHandler',
        'start_day_14_exercise' => 'DayStartHandler',
        'reflection_exercise_completed' => 'DayExerciseCompleteHandler',
        /^start_day_14_/ => 'DayStartHandler',
        /^start_day_15_/ => 'DayStartHandler',
        /^day_15_exercise_completed$/ => 'DayExerciseCompleteHandler',
        /^start_day_16_/ => 'DayStartHandler',
        /^day_16_exercise_completed$/ => 'DayExerciseCompleteHandler',
        'view_reconnection_history' => 'ReconnectionHistoryHandler',
        /^reconnection_/ => 'ReconnectionHistoryHandler',
        'back_to_day_16_menu' => 'MainMenuHandler',
        /^start_day_17_/ => 'DayStartHandler',
        /^day_17_exercise_completed$/ => 'DayExerciseCompleteHandler',
        /^compassion_step_/ => 'CompassionStepHandler',
        'view_compassion_letters' => 'CompassionLettersHandler',
        /^compassion_/ => 'CompassionLettersHandler',
        'back_to_day_17_menu' => 'Day17MenuHandler',
        'continue_after_day_17' => 'ContinueAfterDay17Handler',
        'view_compassion_letters' => 'CompassionLettersHandler',
        /^compassion_show_(\d+)$/ => 'CompassionShowLetterHandler',
        /^compassion_favorite_(\d+)$/ => 'CompassionFavoriteHandler',
        /^compassion_delete_(\d+)$/ => 'CompassionDeleteHandler',
        /^compassion_similar_(\d+)$/ => 'CompassionSimilarHandler',
        /^compassion_by_date$/ => 'CompassionByDateHandler',
        /^compassion_best$/ => 'CompassionBestHandler',
        /^start_day_18/ => 'DayStartHandler',
        'day_18_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_18_feelings_(before|after)_\d+$/ => 'Day18Handler',
        /^day_18_category_/ => 'Day18Handler',
        /^day_18_/ => 'Day18Handler',
        'view_pleasure_activities' => 'PleasureActivitiesHandler',
        'view_activity_ideas' => 'PleasureActivitiesHandler',
        'pleasure_stats' => 'PleasureActivitiesHandler',
        'back_to_day_18_menu' => 'PleasureActivitiesHandler',
        /^start_day_19/ => 'DayStartHandler',
        'day_19_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_19_/ => 'Day19Handler',
        'view_meditation_tips' => 'MeditationTipsHandler',
        'meditation_stats' => 'MeditationStatsHandler',
        'back_to_day_19_menu' => 'MeditationMenuHandler',
        /^start_day_20/ => 'DayStartHandler',
        /^day_20_exercise_completed$/ => 'DayExerciseCompleteHandler',
        /^day_20_/ => 'Day20Handler',
        'view_fear_tips' => 'Day20Handler',
        'view_fear_victories' => 'Day20Handler',
        'back_to_day_20_menu' => 'Day20Handler',
        /^start_day_21/ => 'DayStartHandler',
        'day_21_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_21_/ => 'Day21Handler',
        'view_three_weeks_stats' => 'Day21Handler',
        'view_three_weeks_reflections' => 'Day21Handler',
        'day_21_show_full_reflection' => 'Day21Handler',
        'day_21_show_recommendations' => 'Day21Handler',
        'day_21_show_stats' => 'Day21Handler',
        'day_21_show_reflections' => 'Day21Handler',
        'day_21_review_techniques' => 'Day21Handler',
        'day_21_personal_plan' => 'Day21Handler',
        'day_21_complete_exercise' => 'Day21Handler',
        'back_to_day_21_menu' => 'Day21Handler',
        /^start_day_22/ => 'DayStartHandler',
        'day_22_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_22_/ => 'Day22Handler',
        /^start_day_23/ => 'DayStartHandler',
        'day_23_exercise_completed' => 'DayExerciseCompleteHandler',
        /^day_23_/ => 'Day23Handler',
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
        'complete_day_10' => 'ProgramCompleteHandler',
        'complete_day_7' => 'DayCompleteHandler'
      }.freeze
      
      class << self
        # Найти обработчик для callback_data
        def handler_for(callback_data, params)
          handler_class_name = nil
          matches = nil
          
          # Ищем подходящий обработчик
          HANDLERS_MAP.each do |pattern, handler_name|
            if pattern.is_a?(String)
              if callback_data == pattern
                handler_class_name = handler_name
                break
              end
            elsif pattern.is_a?(Regexp)
              match = callback_data.match(pattern)
              if match
                handler_class_name = handler_name
                matches = match
                break
              end
            end
          end
          
          # Если не нашли обработчик
          if handler_class_name.nil?
            Rails.logger.warn "[CallbackHandlerFactory] No handler found for: #{callback_data}"
            handler_class_name = 'UnknownHandler'
          end
          
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