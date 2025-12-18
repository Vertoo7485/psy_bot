# app/services/self_help/day_state_checker.rb
module SelfHelp
  class DayStateChecker
    DAY_REQUIREMENTS = {
      1 => ['tests_completed', nil, 'program_started'],
      2 => ['day_1_completed', 'awaiting_day_2_start'],
      3 => ['day_2_completed', 'awaiting_day_3_start'],
      4 => ['day_3_completed', 'awaiting_day_4_start'],
      5 => ['day_4_completed', 'awaiting_day_5_start'],
      6 => ['day_5_completed', 'awaiting_day_6_start'],
      7 => ['day_6_completed', 'awaiting_day_7_start'],
      8 => ['day_7_completed', 'awaiting_day_8_start'],
      9 => ['day_8_completed', 'awaiting_day_9_start', 'tests_completed'],
      10 => ['day_9_completed', 'awaiting_day_10_start'],
      11 => ['day_10_completed', 'awaiting_day_11_start'],
      12 => ['day_11_completed', 'awaiting_day_12_start'],
      13 => ['day_12_completed', 'awaiting_day_13_start']
    }.freeze

    def initialize(user)
      @user = user
    end

    def can_start_day?(day_number)
      allowed_states = DAY_REQUIREMENTS[day_number]
      return false unless allowed_states

      allowed_states.include?(@user.self_help_state)
    end
  end
end