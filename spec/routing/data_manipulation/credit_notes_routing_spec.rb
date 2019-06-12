require "rails_helper"

RSpec.describe DataManipulation::CreditNotesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/credit_notes").to route_to("data_manipulation/credit_notes#index")
    end

    it "routes to #new" do
      expect(:get => "/credit_notes/new").to route_to("data_manipulation/credit_notes#new")
    end

    it "routes to #show" do
      expect(:get => "/credit_notes/1").to route_to("data_manipulation/credit_notes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/credit_notes/1/edit").to route_to("data_manipulation/credit_notes#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/credit_notes").to route_to("data_manipulation/credit_notes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/credit_notes/1").to route_to("data_manipulation/credit_notes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/credit_notes/1").to route_to("data_manipulation/credit_notes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/credit_notes/1").to route_to("data_manipulation/credit_notes#destroy", :id => "1")
    end
  end
end
