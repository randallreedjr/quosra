class Question < ApplicationRecord
  validates_presence_of :title

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :category_questions, dependent: :destroy
  has_many :categories, through: :category_questions
end
