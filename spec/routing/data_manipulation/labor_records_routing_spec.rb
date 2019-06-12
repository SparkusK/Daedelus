require "rails_helper"

RSpec.describe DataManipulation::LaborRecordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/labor_records").to route_to("data_manipulation/labor_records#index")
    end

    it "routes to #new" do
      expect(:get => "/labor_records/new").to route_to("data_manipulation/labor_records#new")
    end

    it "routes to #show" do
      expect(:get => "/labor_records/1").to route_to("data_manipulation/labor_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/labor_records/1/edit").to route_to("data_manipulation/labor_records#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/labor_records").to route_to("data_manipulation/labor_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/labor_records/1").to route_to("data_manipulation/labor_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/labor_records/1").to route_to("data_manipulation/labor_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/labor_records/1").to route_to("data_manipulation/labor_records#destroy", :id => "1")
    end
  end
end
