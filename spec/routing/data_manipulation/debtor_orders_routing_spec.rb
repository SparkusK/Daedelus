require "rails_helper"

RSpec.describe DataManipulation::DebtorOrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/debtor_orders").to route_to("data_manipulation/debtor_orders#index")
    end

    it "routes to #new" do
      expect(:get => "/debtor_orders/new").to route_to("data_manipulation/debtor_orders#new")
    end

    it "routes to #show" do
      expect(:get => "/debtor_orders/1").to route_to("data_manipulation/debtor_orders#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/debtor_orders/1/edit").to route_to("data_manipulation/debtor_orders#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/debtor_orders").to route_to("data_manipulation/debtor_orders#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/debtor_orders/1").to route_to("data_manipulation/debtor_orders#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/debtor_orders/1").to route_to("data_manipulation/debtor_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/debtor_orders/1").to route_to("data_manipulation/debtor_orders#destroy", :id => "1")
    end
  end
end
