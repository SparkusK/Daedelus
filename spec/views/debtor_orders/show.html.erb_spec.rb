require 'rails_helper'

RSpec.describe "debtor_orders/show", type: :view do
  before(:each) do
    @debtor_order = assign(:debtor_order, DebtorOrder.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
