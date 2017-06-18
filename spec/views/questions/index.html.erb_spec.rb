require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  let(:question) { FactoryGirl.create(:question, :with_category)}
  let(:question2) { FactoryGirl.create(:question, :with_category)}

  before(:each) do
    assign(:questions, [question, question2])
  end

  it "renders a list of questions" do
    render
    assert_select "h3", text: question.title, count: 1
    assert_select "h3", text: question2.title, count: 1
    assert_select "p", text: question.description, count: 1
    assert_select "p", text: question2.description, count: 1
  end

  it "displays categories for each question" do
    # categories will render twice: once in the filter section, once under the question
    render
    assert_select "span.badge__category", text: question.categories.first.title, count: 1
    assert_select "span", text: question.categories.first.title, count: 2
    assert_select "span.badge__category", text: question2.categories.first.title, count: 1
    assert_select "span", text: question2.categories.first.title, count: 2
  end

  it "hides edit and delete buttons" do
    # questions not associated with any user
    render
    expect(rendered).to_not match(/Edit/)
    expect(rendered).to_not match(/Delete/)
  end
end
