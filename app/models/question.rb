class Question < ApplicationRecord
  validates_presence_of :title

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :category_questions, dependent: :destroy
  has_many :categories, through: :category_questions

  scope :by_categories, -> (category_ids) {
    joins(:category_questions)
    .where(category_questions: {
      category_id: category_ids
    })
    .distinct
  }
end
