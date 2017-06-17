require 'rails_helper'

RSpec.describe CategoryQuestion, type: :model do
  let(:category_question) { FactoryGirl.build(:category_question) }

  describe 'validations' do
    it 'has a valid factory' do
      expect(category_question).to be_valid
    end

    it 'validates presence of category id' do
      expect(category_question).to validate_presence_of(:category_id)
    end

    it 'validates presence of question id' do
      expect(category_question).to validate_presence_of(:question_id)
    end

    it 'validates uniqueness of category id for each question id' do
      expect(category_question).to validate_uniqueness_of(:category_id).scoped_to(:question_id)
    end
  end

  describe 'associations' do
    it 'belongs to a category' do
      expect(category_question).to belong_to :category
    end

    it 'belongs to a question' do
      expect(category_question).to belong_to :question
    end
  end
end
