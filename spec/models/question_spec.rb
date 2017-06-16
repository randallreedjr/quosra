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
    it 'has many answers' do
      expect(question).to have_many(:answers)
    end

    it 'belongs to a user' do
      expect(question).to belong_to :user
    end

    context 'when question is deleted' do
      let(:question) { FactoryGirl.create(:question) }
      let!(:answer) { FactoryGirl.create(:answer, question: question) }

      it 'deletes associated answers' do
        expect { question.destroy }.to change(Answer, :count).by(-1)
      end
    end
  end
end
