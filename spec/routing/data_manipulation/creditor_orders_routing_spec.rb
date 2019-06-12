require "rails_helper"

RSpec.describe DataManipulation::CreditorOrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/creditor_orders").to route_to("data_manipulation/creditor_orders#index")
    end

    it "routes to #new" do
      expect(:get => "/creditor_orders/new").to route_to("data_manipulation/creditor_orders#new")
    end

    it "routes to #show" do
      expect(:get => "/creditor_orders/1").to route_to("data_manipulation/creditor_orders#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/creditor_orders/1/edit").to route_to("data_manipulation/creditor_orders#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/creditor_orders").to route_to("data_manipulation/creditor_orders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/creditor_orders/1").to route_to("data_manipulation/creditor_orders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/creditor_orders/1").to route_to("data_manipulation/creditor_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/creditor_orders/1").to route_to("data_manipulation/creditor_orders#destroy", :id => "1")
    end
  end
end
