require 'rails_helper'

RSpec.describe "categories/index", type: :view do
  before(:each) do
    assign(:categories, [
      Category.create!(
        :title => "Title"
      ),
      Category.create!(
        :title => "Title2"
      )
    ])
  end

  it "renders a list of categories" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 1
    assert_select "tr>td", :text => "Title2".to_s, :count => 1
  end
end
