class Question < ApplicationRecord
  validates_presence_of :title

  has_many :answers, dependent: :destroy
end
