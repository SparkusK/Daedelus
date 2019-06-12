require 'rails_helper'

RSpec.describe "credit_notes/edit", type: :view do
  before(:each) do
    @credit_note = assign(:credit_note, CreditNote.create!(
      :creditor_order => nil,
      :payment_type => "MyString",
      :amount_paid => "",
      :note => "MyString",
      :invoice_code => "MyString"
    ))
  end

  it "renders the edit credit_note form" do
    render

    assert_select "form[action=?][method=?]", credit_note_path(@credit_note), "post" do

      assert_select "input[name=?]", "credit_note[creditor_order_id]"

      assert_select "input[name=?]", "credit_note[payment_type]"

      assert_select "input[name=?]", "credit_note[amount_paid]"

      assert_select "input[name=?]", "credit_note[note]"

      assert_select "input[name=?]", "credit_note[invoice_code]"
    end
  end
end
