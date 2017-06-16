require 'rails_helper'

RSpec.describe "Answers", type: :request do
  describe "GET /answer/:id" do
    let(:question) { FactoryGirl.create(:question) }
    let(:answer) { FactoryGirl.create(:answer) }

    it "completes successfully" do
      get question_answer_path(question_id: question.id, id: answer.id)

      expect(response).to have_http_status(200)
    end
  end
end
