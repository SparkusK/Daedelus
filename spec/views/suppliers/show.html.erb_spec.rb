require 'rails_helper'

RSpec.describe "suppliers/show", type: :view do
  before(:each) do
    @supplier = assign(:supplier, Supplier.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
