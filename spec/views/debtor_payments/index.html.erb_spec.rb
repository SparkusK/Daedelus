require 'rails_helper'

RSpec.describe "debtor_payments/index", type: :view do
  before(:each) do
    assign(:debtor_payments, [
      DebtorPayment.create!(),
      DebtorPayment.create!()
    ])
  end

  it "renders a list of debtor_payments" do
    render
  end
end
