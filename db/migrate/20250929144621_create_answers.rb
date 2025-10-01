class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :test_result, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :answer_option, null: false, foreign_key: true

      t.timestamps
    end
  end
end
