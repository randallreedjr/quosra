require 'rails_helper'

RSpec.describe "answers/edit", type: :view do
  before(:each) do
    @question = FactoryGirl.create(:question)
    @answer = assign(:answer, FactoryGirl.create(:answer, question: @question))
  end

  it "renders the edit answer form" do
    render

    assert_select "form[action=?][method=?]", question_answer_path(@question, @answer), "post" do

      assert_select "textarea#answer_content[name=?]", "answer[content]"
    end
  end
end
