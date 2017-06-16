require 'rails_helper'

RSpec.describe "answers/show", type: :view do
  before(:each) do
    @question = FactoryGirl.create(:question)
    @answer = assign(:answer, FactoryGirl.create(:answer, question: @question))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{CGI.escapeHTML(@answer.content)}/)
    expect(rendered).to match(/#{CGI.escapeHTML(@question.title)}/)
  end
end
