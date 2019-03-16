require 'rails_helper'

RSpec.describe "JobTargets", type: :request do
  describe "GET /job_targets" do
    it "works! (now write some real specs)" do
      get job_targets_path
      expect(response).to have_http_status(200)
    end
  end
end
