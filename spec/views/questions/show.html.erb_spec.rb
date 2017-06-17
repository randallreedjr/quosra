require 'rails_helper'

RSpec.describe "questions/show", type: :view do
  before(:each) do
    @question = assign(:question, FactoryGirl.create(:question, title: 'Title', description: 'MyText'))
    FactoryGirl.create(:answer, question: @question)
    @answers = assign(:answers, Answer.for_question(@question))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end

  it "hides edit and delete button" do
    # question not associated with any user
    render
    expect(rendered).to_not match(/Edit/)
    expect(rendered).to_not match(/Delete/)
  end
end
