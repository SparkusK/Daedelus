require 'rails_helper'

RSpec.describe "credit_notes/show", type: :view do
  before(:each) do
    @credit_note = assign(:credit_note, CreditNote.create!(
      :creditor_order => nil,
      :payment_type => "Payment Type",
      :amount_paid => "",
      :note => "Note",
      :invoice_code => "Invoice Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Payment Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Note/)
    expect(rendered).to match(/Invoice Code/)
  end
end
