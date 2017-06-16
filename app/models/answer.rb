class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates_presence_of :content

  scope :for_question, -> (question_id) { where(question_id: question_id) }
end
