require "rails_helper"

RSpec.describe DataManipulation::ManagersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/managers").to route_to("data_manipulation/managers#index")
    end

    it "routes to #new" do
      expect(:get => "/managers/new").to route_to("data_manipulation/managers#new")
    end

    it "routes to #show" do
      expect(:get => "/managers/1").to route_to("data_manipulation/managers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/managers/1/edit").to route_to("data_manipulation/managers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/managers").to route_to("data_manipulation/managers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/managers/1").to route_to("data_manipulation/managers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/managers/1").to route_to("data_manipulation/managers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/managers/1").to route_to("data_manipulation/managers#destroy", :id => "1")
    end
  end
end
