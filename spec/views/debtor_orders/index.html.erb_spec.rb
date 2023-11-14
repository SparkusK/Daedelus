require 'rails_helper'

RSpec.describe "debtor_orders/index", type: :view do
  before(:each) do
    assign(:debtor_orders, [
      DebtorOrder.create!(),
      DebtorOrder.create!()
    ])
  end

  it "renders a list of debtor_orders" do
    render
  end
end
