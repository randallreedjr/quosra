require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryGirl.build(:category) }

  describe 'validations' do
    it 'has a valid factory' do
      expect(category).to be_valid
    end

    it 'validates presence of title' do
      expect(category).to validate_presence_of(:title)
    end

    it 'validates uniqueness of title' do
      expect(category).to validate_uniqueness_of(:title)
    end
  end

  describe 'associations' do
    it 'has many category questions' do
      expect(category).to have_many(:category_questions)
    end

    it 'has many questions' do
      expect(category).to have_many(:questions).through(:category_questions)
    end

    context 'when category is deleted' do
      let(:question) { FactoryGirl.create(:question, :with_category) }
      let!(:category) { question.categories.first }

      it 'deletes associated category questions' do
        expect { category.destroy }.to change(CategoryQuestion, :count).by(-1)
      end
    end
  end
end
