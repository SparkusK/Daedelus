require 'rails_helper'

RSpec.describe "suppliers/index", type: :view do
  before(:each) do
    assign(:suppliers, [
      Supplier.create!(),
      Supplier.create!()
    ])
  end

  it "renders a list of suppliers" do
    render
  end
end
