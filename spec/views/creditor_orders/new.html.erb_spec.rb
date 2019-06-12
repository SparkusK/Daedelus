require 'rails_helper'

RSpec.describe "creditor_orders/new", type: :view do
  before(:each) do
    assign(:creditor_order, CreditorOrder.new())
  end

  it "renders new creditor_order form" do
    render

    assert_select "form[action=?][method=?]", creditor_orders_path, "post" do
    end
  end
end
