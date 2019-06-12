require "rails_helper"

RSpec.describe DataManipulation::CustomersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/customers").to route_to("data_manipulation/customers#index")
    end

    it "routes to #new" do
      expect(:get => "/customers/new").to route_to("data_manipulation/customers#new")
    end

    it "routes to #show" do
      expect(:get => "/customers/1").to route_to("data_manipulation/customers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/customers/1/edit").to route_to("data_manipulation/customers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/customers").to route_to("data_manipulation/customers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/customers/1").to route_to("data_manipulation/customers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/customers/1").to route_to("data_manipulation/customers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/customers/1").to route_to("data_manipulation/customers#destroy", :id => "1")
    end
  end
end
