require 'rails_helper'

RSpec.describe "job_targets/new", type: :view do
  before(:each) do
    assign(:job_target, JobTarget.new(
      :invoice_number => "MyString",
      :remarks => "MyString",
      :details => "MyString",
      :target_amount => "9.99",
      :section => nil,
      :job => nil
    ))
  end

  it "renders new job_target form" do
    render

    assert_select "form[action=?][method=?]", job_targets_path, "post" do

      assert_select "input[name=?]", "job_target[invoice_number]"

      assert_select "input[name=?]", "job_target[remarks]"

      assert_select "input[name=?]", "job_target[details]"

      assert_select "input[name=?]", "job_target[target_amount]"

      assert_select "input[name=?]", "job_target[section_id]"

      assert_select "input[name=?]", "job_target[job_id]"
    end
  end
end
