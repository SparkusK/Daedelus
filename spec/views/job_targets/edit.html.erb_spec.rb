require 'rails_helper'

RSpec.describe "job_targets/edit", type: :view do
  before(:each) do
    @job_target = assign(:job_target, JobTarget.create!(
      :invoice_number => "MyString",
      :remarks => "MyString",
      :details => "MyString",
      :target_amount => "9.99",
      :section => nil,
      :job => nil
    ))
  end

  it "renders the edit job_target form" do
    render

    assert_select "form[action=?][method=?]", job_target_path(@job_target), "post" do

      assert_select "input[name=?]", "job_target[invoice_number]"

      assert_select "input[name=?]", "job_target[remarks]"

      assert_select "input[name=?]", "job_target[details]"

      assert_select "input[name=?]", "job_target[target_amount]"

      assert_select "input[name=?]", "job_target[section_id]"

      assert_select "input[name=?]", "job_target[job_id]"
    end
  end
end
