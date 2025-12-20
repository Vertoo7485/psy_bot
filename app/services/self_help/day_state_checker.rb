module SelfHelp
  class DayStateChecker
    DAY_REQUIREMENTS = {
      1 => ['tests_completed', nil, 'program_started', 'awaiting_day_1_start'],
      2 => ['day_1_completed', 'awaiting_day_2_start'],
      3 => ['day_2_completed', 'awaiting_day_3_start'],
      4 => ['day_3_completed', 'awaiting_day_4_start'],
      5 => ['day_4_completed', 'awaiting_day_5_start'],
      6 => ['day_5_completed', 'awaiting_day_6_start'],
      7 => ['day_6_completed', 'awaiting_day_7_start'],
      8 => ['day_7_completed', 'awaiting_day_8_start'],
      9 => ['day_8_completed', 'awaiting_day_9_start', 'tests_completed', 'awaiting_day_9_start'],
      10 => ['day_9_completed', 'awaiting_day_10_start'],
      11 => ['day_10_completed', 'awaiting_day_11_start'],
      12 => ['day_11_completed', 'awaiting_day_12_start'],
      13 => ['day_12_completed', 'awaiting_day_13_start'],
      14 => ['day_13_completed', 'awaiting_day_14_start'],  # ⬅️ ДОБАВЛЕНО
      15 => ['day_14_completed', 'awaiting_day_15_start'],  # ⬅️ ДЛЯ БУДУЩЕГО
      16 => ['day_15_completed', 'awaiting_day_16_start'],
      17 => ['day_16_completed', 'awaiting_day_17_start'],
      18 => ['day_17_completed', 'awaiting_day_18_start'],
      19 => ['day_18_completed', 'awaiting_day_19_start'],
      20 => ['day_19_completed', 'awaiting_day_20_start'],
      21 => ['day_20_completed', 'awaiting_day_21_start'],
      22 => ['day_21_completed', 'awaiting_day_22_start'],
      23 => ['day_22_completed', 'awaiting_day_23_start'],
      24 => ['day_23_completed', 'awaiting_day_24_start'],
      25 => ['day_24_completed', 'awaiting_day_25_start'],
      26 => ['day_25_completed', 'awaiting_day_26_start'],
      27 => ['day_26_completed', 'awaiting_day_27_start'],
      28 => ['day_27_completed', 'awaiting_day_28_start']
    }.freeze

    def initialize(user)
      @user = user
    end

    def can_start_day?(day_number)
      # Для дней, которых нет в списке, возвращаем false
      return false if day_number > 28 || day_number < 1
      
      allowed_states = DAY_REQUIREMENTS[day_number]
      return false unless allowed_states

      allowed_states.include?(@user.self_help_state)
    end
  end
end