require 'rails_helper'

RSpec.describe "debtor_payments/show", type: :view do
  before(:each) do
    @debtor_payment = assign(:debtor_payment, DebtorPayment.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
