require 'rails_helper'

RSpec.describe "LaborRecords", type: :request do
  describe "GET /labor_records" do
    it "works! (now write some real specs)" do
      get labor_records_path
      expect(response).to have_http_status(200)
    end
  end
end
