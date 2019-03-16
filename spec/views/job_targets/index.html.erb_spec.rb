require 'rails_helper'

RSpec.describe "job_targets/index", type: :view do
  before(:each) do
    assign(:job_targets, [
      JobTarget.create!(
        :invoice_number => "Invoice Number",
        :remarks => "Remarks",
        :details => "Details",
        :target_amount => "9.99",
        :section => nil,
        :job => nil
      ),
      JobTarget.create!(
        :invoice_number => "Invoice Number",
        :remarks => "Remarks",
        :details => "Details",
        :target_amount => "9.99",
        :section => nil,
        :job => nil
      )
    ])
  end

  it "renders a list of job_targets" do
    render
    assert_select "tr>td", :text => "Invoice Number".to_s, :count => 2
    assert_select "tr>td", :text => "Remarks".to_s, :count => 2
    assert_select "tr>td", :text => "Details".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
