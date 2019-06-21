require 'rails_helper'

RSpec.describe "creditor_payments/show", type: :view do
  before(:each) do
    @creditor_payment = assign(:creditor_payment, CreditorPayment.create!(
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
