require 'rails_helper'

RSpec.describe "creditor_orders/show", type: :view do
  before(:each) do
    @creditor_order = assign(:creditor_order, CreditorOrder.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
