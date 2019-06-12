require 'rails_helper'

RSpec.describe "labor_records/index", type: :view do
  before(:each) do
    assign(:labor_records, [
      LaborRecord.create!(),
      LaborRecord.create!()
    ])
  end

  it "renders a list of labor_records" do
    render
  end
end
