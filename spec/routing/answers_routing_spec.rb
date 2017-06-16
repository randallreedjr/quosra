require "rails_helper"

RSpec.describe AnswersController, type: :routing do
  describe "routing" do

    let(:question) { FactoryGirl.create(:question) }

    it "routes to #new" do
      expect(:get => "/questions/#{question.id}/answers/new").to route_to("answers#new", question_id: "#{question.id}")
    end

    it "routes to #show" do
      expect(:get => "/questions/#{question.id}/answers/1").to route_to("answers#show", id: "1", question_id: "#{question.id}")
    end

    it "routes to #edit" do
      expect(:get => "/questions/#{question.id}/answers/1/edit").to route_to("answers#edit", id: "1", question_id: "#{question.id}")
    end

    it "routes to #create" do
      expect(:post => "/questions/#{question.id}/answers").to route_to("answers#create", question_id: "#{question.id}")
    end

    it "routes to #update via PUT" do
      expect(:put => "/questions/#{question.id}/answers/1").to route_to("answers#update", id: "1", question_id: "#{question.id}")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/questions/#{question.id}/answers/1").to route_to("answers#update", id: "1", question_id: "#{question.id}")
    end

    it "routes to #destroy" do
      expect(:delete => "/questions/#{question.id}/answers/1").to route_to("answers#destroy", id: "1", question_id: "#{question.id}")
    end
  end
end
