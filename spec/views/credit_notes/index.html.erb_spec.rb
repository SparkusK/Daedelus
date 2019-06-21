require 'rails_helper'

RSpec.describe "creditor_payments/index", type: :view do
  before(:each) do
    assign(:creditor_payments, [
      CreditorPayment.create!(
        :creditor_order => nil,
        :payment_type => "Payment Type",
        :amount_paid => "",
        :note => "Note",
        :invoice_code => "Invoice Code"
      ),
      CreditorPayment.create!(
        :creditor_order => nil,
        :payment_type => "Payment Type",
        :amount_paid => "",
        :note => "Note",
        :invoice_code => "Invoice Code"
      )
    ])
  end

  it "renders a list of creditor_payments" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Payment Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Note".to_s, :count => 2
    assert_select "tr>td", :text => "Invoice Code".to_s, :count => 2
  end
end
