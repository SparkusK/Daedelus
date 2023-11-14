require "rails_helper"

RSpec.describe DataManipulation::EmployeesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/employees").to route_to("data_manipulation/employees#index")
    end

    it "routes to #new" do
      expect(:get => "/employees/new").to route_to("data_manipulation/employees#new")
    end

    it "routes to #show" do
      expect(:get => "/employees/1").to route_to("data_manipulation/employees#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/employees/1/edit").to route_to("data_manipulation/employees#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/employees").to route_to("data_manipulation/employees#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/employees/1").to route_to("data_manipulation/employees#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/employees/1").to route_to("data_manipulation/employees#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/employees/1").to route_to("data_manipulation/employees#destroy", :id => "1")
    end
  end
end
