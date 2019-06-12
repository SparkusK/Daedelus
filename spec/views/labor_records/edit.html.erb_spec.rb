require 'rails_helper'

RSpec.describe "labor_records/edit", type: :view do
  before(:each) do
    @labor_record = assign(:labor_record, LaborRecord.create!())
  end

  it "renders the edit labor_record form" do
    render

    assert_select "form[action=?][method=?]", labor_record_path(@labor_record), "post" do
    end
  end
end
