require 'rails_helper'

RSpec.describe "debtor_orders/edit", type: :view do
  before(:each) do
    @debtor_order = assign(:debtor_order, DebtorOrder.create!())
  end

  it "renders the edit debtor_order form" do
    render

    assert_select "form[action=?][method=?]", debtor_order_path(@debtor_order), "post" do
    end
  end
end
