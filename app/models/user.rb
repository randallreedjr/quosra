class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable has been disable since we are not setting up a mailer
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
end
