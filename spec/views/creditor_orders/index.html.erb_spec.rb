require 'rails_helper'

RSpec.describe "creditor_orders/index", type: :view do
  before(:each) do
    assign(:creditor_orders, [
      CreditorOrder.create!(),
      CreditorOrder.create!()
    ])
  end

  it "renders a list of creditor_orders" do
    render
  end
end
