require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { FactoryGirl.build(:question) }

  describe 'validations' do
    it 'has a valid factory' do
      expect(question).to be_valid
    end

    it 'validates presence of title' do
      expect(question).to validate_presence_of(:title)
    end
  end

  describe 'associations' do
    it 'belongs to a user' do
      expect(question).to belong_to :user
    end

    it 'has many answers' do
      expect(question).to have_many(:answers)
    end

    it 'has many category questions' do
      expect(question).to have_many(:category_questions)
    end

    it 'has many categories' do
      expect(question).to have_many(:categories).through(:category_questions)
    end

    context 'when question is deleted' do
      let(:question) { FactoryGirl.create(:question, :with_category) }
      let!(:answer) { FactoryGirl.create(:answer, question: question) }

      it 'deletes associated answers' do
        expect { question.destroy }.to change(Answer, :count).by(-1)
      end

      it 'deletes associated category questions' do
        expect { question.destroy }.to change(CategoryQuestion, :count).by(-1)
      end
    end
  end

  describe 'scopes' do
    describe 'by categories' do
      it 'retrieves questions for the given category' do
        category_ids = Category.all.pluck(:id)

        expect(Question.by_categories(category_ids).to_sql).to eq(
          Question.joins(:category_questions).where(category_questions: { category_id: category_ids}).distinct.to_sql
        )
      end
    end
  end
end
