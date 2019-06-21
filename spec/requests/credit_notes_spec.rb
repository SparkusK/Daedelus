require 'rails_helper'

RSpec.describe "CreditorPayments", type: :request do
  describe "GET /creditor_payments" do
    it "works! (now write some real specs)" do
      get creditor_payments_path
      expect(response).to have_http_status(200)
    end
  end
end
