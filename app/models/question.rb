class Question < ApplicationRecord
  validates_presence_of :title

  belongs_to :user
  has_many :answers, dependent: :destroy
end
