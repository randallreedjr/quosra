class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :category_questions, dependent: :destroy
  has_many :categories, through: :category_questions

  validates_presence_of :title

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name [Rails.env, 'questions'].join('_')

  scope :by_category, -> (category_id) {
    joins(:category_questions)
    .where(category_questions: {
      category_id: category_id
    })
  }

  def as_indexed_json(options={})
    self.as_json(
      include: {
        categories: { methods: [:title], only: [:title] },
        answers: { methods: [:content], only: [:content] }
      }
    )
  end
end
