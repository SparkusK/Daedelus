require 'rails_helper'

RSpec.describe "labor_records/show", type: :view do
  before(:each) do
    @labor_record = assign(:labor_record, LaborRecord.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
