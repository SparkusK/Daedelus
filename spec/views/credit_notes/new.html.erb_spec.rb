require 'rails_helper'

RSpec.describe "creditor_payments/new", type: :view do
  before(:each) do
    assign(:creditor_payment, CreditorPayment.new(
      :creditor_order => nil,
      :payment_type => "MyString",
      :amount_paid => "",
      :note => "MyString",
      :invoice_code => "MyString"
    ))
  end

  it "renders new creditor_payment form" do
    render

    assert_select "form[action=?][method=?]", creditor_payments_path, "post" do

      assert_select "input[name=?]", "creditor_payment[creditor_order_id]"

      assert_select "input[name=?]", "creditor_payment[payment_type]"

      assert_select "input[name=?]", "creditor_payment[amount_paid]"

      assert_select "input[name=?]", "creditor_payment[note]"

      assert_select "input[name=?]", "creditor_payment[invoice_code]"
    end
  end
end
