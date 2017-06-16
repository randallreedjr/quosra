require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'validations' do
    let(:answer) { FactoryGirl.build(:answer) }

    it 'has a valid factory' do
      expect(answer).to be_valid
    end

    it 'validates presence of content' do
      expect(answer).to validate_presence_of(:content)
    end
  end

  describe 'associations' do
    let(:answer) { FactoryGirl.build(:answer) }

    it 'belongs to a question' do
      expect(answer).to belong_to :question
    end
  end

  describe 'scopes' do
    describe 'for question' do
      let(:question) { FactoryGirl.create(:question) }
      it 'retrieves answers for the given question' do
        expect(Answer.for_question(question.id).to_sql).to eq(Answer.where(question_id: question.id).to_sql)
      end
    end
  end
end
