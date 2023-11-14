require 'rails_helper'

RSpec.describe "DebtorPayments", type: :request do
  describe "GET /debtor_payments" do
    it "works! (now write some real specs)" do
      get debtor_payments_path
      expect(response).to have_http_status(200)
    end
  end
end
