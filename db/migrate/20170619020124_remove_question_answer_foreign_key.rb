class RemoveQuestionAnswerForeignKey < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :answers, column: :question_id
  end
end
