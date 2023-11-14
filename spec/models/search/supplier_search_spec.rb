require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_supplier = FactoryBot.create(:incorrect_supplier) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Supplier via its Name" do
        correct_supplier = FactoryBot.create(:supplier, name: "C")
        suppliers = Supplier.search(keywords: "C")
        expect(suppliers.map(&:id)).to contain_exactly(correct_supplier.id)
      end

      it "finds the correct Supplier via its Email" do
        correct_supplier = FactoryBot.create(:supplier, email: "C")
        suppliers = Supplier.search(keywords: "C")
        expect(suppliers.map(&:id)).to contain_exactly(correct_supplier.id)
      end

      it "finds the correct Supplier via its Phone" do
        correct_supplier = FactoryBot.create(:supplier, phone: "C")
        suppliers = Supplier.search(keywords: "C")
        expect(suppliers.map(&:id)).to contain_exactly(correct_supplier.id)
      end
    end
  end
end
