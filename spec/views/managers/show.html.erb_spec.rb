require 'rails_helper'

RSpec.describe "managers/show", type: :view do
  before(:each) do
    @manager = assign(:manager, Manager.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
