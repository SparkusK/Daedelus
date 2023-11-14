require 'rails_helper'

RSpec.describe "labor_records/new", type: :view do
  before(:each) do
    assign(:labor_record, LaborRecord.new())
  end

  it "renders new labor_record form" do
    render

    assert_select "form[action=?][method=?]", labor_records_path, "post" do
    end
  end
end
