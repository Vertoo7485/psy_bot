# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#     
user = User.create(telegram_id: 123456789, first_name: "Test", last_name: "User", username: "testuser")

   test = Test.create(name: "Пример теста", description: "Это пример психологического теста.")

   question1 = Question.create(test: test, text: "Как вы себя чувствуете сегодня?")
   AnswerOption.create(question: question1, text: "Отлично", value: 0)
   AnswerOption.create(question: question1, text: "Хорошо", value: 1)
   AnswerOption.create(question: question1, text: "Нормально", value: 2)
   AnswerOption.create(question: question1, text: "Плохо", value: 3)

   question2 = Question.create(test: test, text: "Что вы планируете делать вечером?")
   AnswerOption.create(question: question2, text: "Отдыхать", value: 0)
   AnswerOption.create(question: question2, text: "Работать", value: 1)
   AnswerOption.create(question: question2, text: "Заниматься спортом", value: 2)
# end
