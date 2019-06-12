require 'rails_helper'

RSpec.describe "DebtorOrders", type: :request do
  describe "GET /debtor_orders" do
    it "works! (now write some real specs)" do
      get debtor_orders_path
      expect(response).to have_http_status(200)
    end
  end
end
