require 'rails_helper'

RSpec.describe "debtor_payments/new", type: :view do
  before(:each) do
    assign(:debtor_payment, DebtorPayment.new())
  end

  it "renders new debtor_payment form" do
    render

    assert_select "form[action=?][method=?]", debtor_payments_path, "post" do
    end
  end
end
