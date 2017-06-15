require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'validations' do
    let(:question) { FactoryGirl.build(:question) }

    it 'has a valid factory' do
      expect(question).to be_valid
    end

    it 'validates presence of title' do
      expect(question).to validate_presence_of(:title)
    end
  end
end
