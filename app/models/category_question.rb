class CategoryQuestion < ApplicationRecord
  belongs_to :category
  belongs_to :question

  validates_uniqueness_of :category_id, scope: :question_id
  validates_presence_of :category_id
  validates_presence_of :question_id
end
