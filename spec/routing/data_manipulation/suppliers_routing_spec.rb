require "rails_helper"

RSpec.describe DataManipulation::SuppliersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/suppliers").to route_to("data_manipulation/suppliers#index")
    end

    it "routes to #new" do
      expect(:get => "/suppliers/new").to route_to("data_manipulation/suppliers#new")
    end

    it "routes to #show" do
      expect(:get => "/suppliers/1").to route_to("data_manipulation/suppliers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/suppliers/1/edit").to route_to("data_manipulation/suppliers#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/suppliers").to route_to("data_manipulation/suppliers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/suppliers/1").to route_to("data_manipulation/suppliers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/suppliers/1").to route_to("data_manipulation/suppliers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/suppliers/1").to route_to("data_manipulation/suppliers#destroy", :id => "1")
    end
  end
end
