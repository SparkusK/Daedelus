require "rails_helper"

RSpec.describe DataManipulation::CreditorPaymentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/creditor_payments").to route_to("data_manipulation/creditor_payments#index")
    end

    it "routes to #new" do
      expect(:get => "/creditor_payments/new").to route_to("data_manipulation/creditor_payments#new")
    end

    it "routes to #show" do
      expect(:get => "/creditor_payments/1").to route_to("data_manipulation/creditor_payments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/creditor_payments/1/edit").to route_to("data_manipulation/creditor_payments#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/creditor_payments").to route_to("data_manipulation/creditor_payments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/creditor_payments/1").to route_to("data_manipulation/creditor_payments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/creditor_payments/1").to route_to("data_manipulation/creditor_payments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/creditor_payments/1").to route_to("data_manipulation/creditor_payments#destroy", :id => "1")
    end
  end
end
