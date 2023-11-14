require 'rails_helper'

RSpec.describe "debtor_payments/edit", type: :view do
  before(:each) do
    @debtor_payment = assign(:debtor_payment, DebtorPayment.create!())
  end

  it "renders the edit debtor_payment form" do
    render

    assert_select "form[action=?][method=?]", debtor_payment_path(@debtor_payment), "post" do
    end
  end
end
