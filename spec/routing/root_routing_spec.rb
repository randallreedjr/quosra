require "rails_helper"

RSpec.describe 'Root route', type: :routing do


    it "routes to #index" do
      expect(:get => "/").to route_to("questions#index")
    end
  end
