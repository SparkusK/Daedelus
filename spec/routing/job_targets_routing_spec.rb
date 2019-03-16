require "rails_helper"

RSpec.describe JobTargetsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/job_targets").to route_to("job_targets#index")
    end

    it "routes to #new" do
      expect(:get => "/job_targets/new").to route_to("job_targets#new")
    end

    it "routes to #show" do
      expect(:get => "/job_targets/1").to route_to("job_targets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/job_targets/1/edit").to route_to("job_targets#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/job_targets").to route_to("job_targets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/job_targets/1").to route_to("job_targets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/job_targets/1").to route_to("job_targets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/job_targets/1").to route_to("job_targets#destroy", :id => "1")
    end
  end
end
