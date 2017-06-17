require 'rails_helper'

RSpec.describe "questions/index", type: :view do
  before(:each) do
    assign(:questions, [
      FactoryGirl.create(
        :question,
        :with_category,
        title: "Title",
        description: "MyText"
      ),
      FactoryGirl.create(
        :question,
        :with_category,
        title: "Title",
        description: "MyOtherText"
      )
    ])
  end

  it "renders a list of questions" do
    render
    assert_select "h3", text: "Title".to_s, count: 2
    assert_select "p", text: "MyText".to_s, count: 1
    assert_select "p", text: "MyOtherText".to_s, count: 1
  end

  it "displays categories for each question" do
    render
    assert_select "span", text: Category.first.title, count: 1
    assert_select "span", text: Category.last.title, count: 1
  end

  it "hides edit and delete button" do
    # questions not associated with any user
    render
    expect(rendered).to_not match(/Edit/)
    expect(rendered).to_not match(/Delete/)
  end
end
