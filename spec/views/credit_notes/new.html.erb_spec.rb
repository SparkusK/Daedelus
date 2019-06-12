require 'rails_helper'

RSpec.describe "credit_notes/new", type: :view do
  before(:each) do
    assign(:credit_note, CreditNote.new(
      :creditor_order => nil,
      :payment_type => "MyString",
      :amount_paid => "",
      :note => "MyString",
      :invoice_code => "MyString"
    ))
  end

  it "renders new credit_note form" do
    render

    assert_select "form[action=?][method=?]", credit_notes_path, "post" do

      assert_select "input[name=?]", "credit_note[creditor_order_id]"

      assert_select "input[name=?]", "credit_note[payment_type]"

      assert_select "input[name=?]", "credit_note[amount_paid]"

      assert_select "input[name=?]", "credit_note[note]"

      assert_select "input[name=?]", "credit_note[invoice_code]"
    end
  end
end
