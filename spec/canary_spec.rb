require 'rails_helper'

test_fail = false
# test_fail = true

describe "rspec is configured properly" do
  it "should pass" do
    expect(true).to eq(true)
  end

  if test_fail
    it "can fail" do
      expect(false).to eq(true)
    end
  end
end
