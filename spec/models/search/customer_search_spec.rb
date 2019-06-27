require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_customer = FactoryBot.create(:incorrect_customer) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Customer via its Name" do
        correct_customer = FactoryBot.create(:customer, name: "C")
        customers = Customer.search(keywords: "C")
        expect(customers.map(&:id)).to contain_exactly(correct_customer.id)
      end

      it "finds the correct Customer via its Email" do
        correct_customer = FactoryBot.create(:customer, email: "C")
        customers = Customer.search(keywords: "C")
        expect(customers.map(&:id)).to contain_exactly(correct_customer.id)
      end

      it "finds the correct Customer via its Phone" do
        correct_customer = FactoryBot.create(:customer, phone: "C")
        customers = Customer.search(keywords: "C")
        expect(customers.map(&:id)).to contain_exactly(correct_customer.id)
      end
    end
  end
end
