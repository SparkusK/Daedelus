require 'rails_helper'

RSpec.describe "credit_notes/index", type: :view do
  before(:each) do
    assign(:credit_notes, [
      CreditNote.create!(
        :creditor_order => nil,
        :payment_type => "Payment Type",
        :amount_paid => "",
        :note => "Note",
        :invoice_code => "Invoice Code"
      ),
      CreditNote.create!(
        :creditor_order => nil,
        :payment_type => "Payment Type",
        :amount_paid => "",
        :note => "Note",
        :invoice_code => "Invoice Code"
      )
    ])
  end

  it "renders a list of credit_notes" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Payment Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Note".to_s, :count => 2
    assert_select "tr>td", :text => "Invoice Code".to_s, :count => 2
  end
end
