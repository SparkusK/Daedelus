require 'rails_helper'

RSpec.describe "managers/edit", type: :view do
  before(:each) do
    @manager = assign(:manager, Manager.create!())
  end

  it "renders the edit manager form" do
    render

    assert_select "form[action=?][method=?]", manager_path(@manager), "post" do
    end
  end
end
