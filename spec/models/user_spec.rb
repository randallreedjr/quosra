require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { FactoryGirl.build(:user) }

    it 'has a valid factory' do
      expect(user).to be_valid
    end
  end

  describe 'associations' do
    let(:user) { FactoryGirl.build(:user) }

    it 'has many questions' do
      expect(user).to have_many :questions
    end

    it 'has many answers' do
      expect(user).to have_many :answers
    end
  end
end
