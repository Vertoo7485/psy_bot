# app/services/self_help/days/emotion_diary_sequence_service.rb

def complete_diary_entry_for_day_10
  begin
    # Собираем все ответы
    diary_data = {}
    STEP_KEYS.each do |step|
      diary_data[step] = get_step_answer(step)
    end
    
    # Создаем запись в базе данных
    EmotionDiaryEntry.create!(
      user: @user,
      date: Date.current,
      situation: diary_data['situation'],
      thoughts: diary_data['thoughts'],
      emotions: diary_data['emotions'],
      behavior: diary_data['behavior'],
      evidence_against: diary_data['evidence_against'],
      new_thoughts: diary_data['new_thoughts']
    )
    
    # Очищаем временные данные
    clear_temporary_data
    
    # ИЗМЕНЕНИЕ: После сохранения дневника вызываем метод завершения Day10Service
    day_service = Day10Service.new(@bot_service, @user, @chat_id)
    
    # Отправляем сообщение о завершении
    send_message(
      text: "✅ *Дневник эмоций успешно заполнен и сохранен!*\n\nВы проделали отличную работу по анализу своих эмоций и мыслей.",
      parse_mode: 'Markdown'
    )
    
    # ИЗМЕНЕНИЕ: Теперь НЕ отправляем кнопку day_10_exercise_completed
    # Вместо этого вызываем метод завершения упражнения
    send_message(
      text: "Завершаем день 10...",
      parse_mode: 'Markdown'
    )
    
    # Вызываем метод завершения
    day_service.complete_exercise_after_diary
    
  rescue ActiveRecord::RecordInvalid => e
    log_error("Ошибка при сохранении записи дневника", e)
    send_message(text: "Произошла ошибка при сохранении записи. Попробуйте еще раз.")
  end
end