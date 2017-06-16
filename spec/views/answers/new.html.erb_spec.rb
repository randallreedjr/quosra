require 'rails_helper'

RSpec.describe "answers/new", type: :view do
  before(:each) do
    @question = FactoryGirl.create(:question)
    @answer = assign(:answer, FactoryGirl.build(:answer, question: @question))
  end

  it "renders new answer form" do
    render

    assert_select "form[action=?][method=?]", question_answers_path(@question, @answer), "post" do

      assert_select "textarea#answer_content[name=?]", "answer[content]"
    end
  end
end
