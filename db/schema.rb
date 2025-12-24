# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_12_23_150601) do
  create_table "answer_options", force: :cascade do |t|
    t.integer "question_id", null: false
    t.string "text"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answer_options_on_question_id"
  end

  create_table "answers", force: :cascade do |t|
    t.integer "test_result_id", null: false
    t.integer "question_id", null: false
    t.integer "answer_option_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_option_id"], name: "index_answers_on_answer_option_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["test_result_id"], name: "index_answers_on_test_result_id"
  end

  create_table "anxious_thought_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.text "thought"
    t.integer "probability"
    t.text "facts_pro"
    t.text "facts_con"
    t.text "reframe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "entry_date"], name: "index_anxious_thought_entries_on_user_id_and_entry_date"
    t.index ["user_id"], name: "index_anxious_thought_entries_on_user_id"
  end

  create_table "compassion_letters", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.text "situation_text"
    t.text "understanding_text"
    t.text "kindness_text"
    t.text "advice_text"
    t.text "closure_text"
    t.text "full_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_compassion_letters_on_user_id"
  end

  create_table "emotion_diary_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "date"
    t.text "situation"
    t.text "thoughts"
    t.text "emotions"
    t.text "behavior"
    t.text "evidence_against"
    t.text "new_thoughts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_emotion_diary_entries_on_user_id"
  end

  create_table "gratitude_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.text "entry_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_gratitude_entries_on_user_id"
  end

  create_table "grounding_exercise_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.text "seen"
    t.text "touched"
    t.text "heard"
    t.text "smelled"
    t.text "tasted"
    t.text "feelings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_grounding_exercise_entries_on_user_id"
  end

  create_table "meditation_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pleasure_activities", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title"
    t.text "description"
    t.string "activity_type"
    t.integer "duration"
    t.boolean "completed"
    t.datetime "completed_at"
    t.integer "feelings_before"
    t.integer "feelings_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pleasure_activities_on_user_id"
  end

  create_table "procrastination_tasks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.text "task"
    t.text "reason"
    t.text "steps"
    t.text "first_step"
    t.boolean "completed"
    t.text "feelings_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_procrastination_tasks_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "test_id", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "part"
    t.index ["test_id"], name: "index_questions_on_test_id"
  end

  create_table "reconnection_practices", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.string "reconnected_person"
    t.string "communication_format"
    t.text "conversation_start"
    t.text "reflection_text"
    t.text "integration_plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reconnection_practices_on_user_id"
  end

  create_table "reflection_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.text "entry_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reflection_entries_on_user_id"
  end

  create_table "self_compassion_practices", force: :cascade do |t|
    t.integer "user_id", null: false
    t.date "entry_date"
    t.text "current_difficulty"
    t.text "common_humanity"
    t.text "kind_words"
    t.text "physical_comfort"
    t.text "mantra"
    t.text "feelings_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_self_compassion_practices_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "test_results", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "test_id", null: false
    t.integer "score"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "luscher_choices"
    t.index ["test_id"], name: "index_test_results_on_test_id"
    t.index ["user_id"], name: "index_test_results_on_user_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "test_type"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "last_activity_at"
    t.string "last_successful_step"
    t.text "current_data"
    t.string "session_type"
    t.text "message_queue"
    t.integer "retry_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "telegram_id"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "current_diary_step"
    t.json "diary_data"
    t.string "self_help_program_step"
    t.json "self_help_program_data", default: {}, null: false
    t.index ["telegram_id"], name: "index_users_on_telegram_id", unique: true
  end

  add_foreign_key "answer_options", "questions"
  add_foreign_key "answers", "answer_options"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "test_results"
  add_foreign_key "anxious_thought_entries", "users"
  add_foreign_key "compassion_letters", "users"
  add_foreign_key "emotion_diary_entries", "users"
  add_foreign_key "gratitude_entries", "users"
  add_foreign_key "grounding_exercise_entries", "users"
  add_foreign_key "pleasure_activities", "users"
  add_foreign_key "procrastination_tasks", "users"
  add_foreign_key "questions", "tests"
  add_foreign_key "reconnection_practices", "users"
  add_foreign_key "reflection_entries", "users"
  add_foreign_key "self_compassion_practices", "users"
  add_foreign_key "test_results", "tests"
  add_foreign_key "test_results", "users"
  add_foreign_key "user_sessions", "users"
end
