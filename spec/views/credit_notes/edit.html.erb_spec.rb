require 'rails_helper'

RSpec.describe "creditor_payments/edit", type: :view do
  before(:each) do
    @creditor_payment = assign(:creditor_payment, CreditorPayment.create!(
      :creditor_order => nil,
      :payment_type => "MyString",
      :amount_paid => "",
      :note => "MyString",
      :invoice_code => "MyString"
    ))
  end

  it "renders the edit creditor_payment form" do
    render

    assert_select "form[action=?][method=?]", creditor_payment_path(@creditor_payment), "post" do

      assert_select "input[name=?]", "creditor_payment[creditor_order_id]"

      assert_select "input[name=?]", "creditor_payment[payment_type]"

      assert_select "input[name=?]", "creditor_payment[amount_paid]"

      assert_select "input[name=?]", "creditor_payment[note]"

      assert_select "input[name=?]", "creditor_payment[invoice_code]"
    end
  end
end
