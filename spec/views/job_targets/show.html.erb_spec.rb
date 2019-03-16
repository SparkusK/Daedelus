require 'rails_helper'

RSpec.describe "job_targets/show", type: :view do
  before(:each) do
    @job_target = assign(:job_target, JobTarget.create!(
      :invoice_number => "Invoice Number",
      :remarks => "Remarks",
      :details => "Details",
      :target_amount => "9.99",
      :section => nil,
      :job => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Invoice Number/)
    expect(rendered).to match(/Remarks/)
    expect(rendered).to match(/Details/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
