require 'rails_helper'

RSpec.describe "debtor_orders/new", type: :view do
  before(:each) do
    assign(:debtor_order, DebtorOrder.new())
  end

  it "renders new debtor_order form" do
    render

    assert_select "form[action=?][method=?]", debtor_orders_path, "post" do
    end
  end
end
