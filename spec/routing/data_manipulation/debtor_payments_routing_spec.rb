require "rails_helper"

RSpec.describe DataManipulation::DebtorPaymentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/debtor_payments").to route_to("data_manipulation/debtor_payments#index")
    end

    it "routes to #new" do
      expect(:get => "/debtor_payments/new").to route_to("data_manipulation/debtor_payments#new")
    end

    it "routes to #show" do
      expect(:get => "/debtor_payments/1").to route_to("data_manipulation/debtor_payments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/debtor_payments/1/edit").to route_to("data_manipulation/debtor_payments#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/debtor_payments").to route_to("data_manipulation/debtor_payments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/debtor_payments/1").to route_to("data_manipulation/debtor_payments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/debtor_payments/1").to route_to("data_manipulation/debtor_payments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/debtor_payments/1").to route_to("data_manipulation/debtor_payments#destroy", :id => "1")
    end
  end
end
