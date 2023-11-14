require 'rails_helper'

RSpec.describe "creditor_orders/edit", type: :view do
  before(:each) do
    @creditor_order = assign(:creditor_order, CreditorOrder.create!())
  end

  it "renders the edit creditor_order form" do
    render

    assert_select "form[action=?][method=?]", creditor_order_path(@creditor_order), "post" do
    end
  end
end
