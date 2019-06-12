require 'rails_helper'

RSpec.describe "managers/index", type: :view do
  before(:each) do
    assign(:managers, [
      Manager.create!(),
      Manager.create!()
    ])
  end

  it "renders a list of managers" do
    render
  end
end
