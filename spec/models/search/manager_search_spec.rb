require 'rails_helper'

RSpec.describe Manager, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_manager = FactoryBot.create(:manager,
        employee_id: FactoryBot.create(:employee, first_name: "A", last_name: "A").id,
        section_id: FactoryBot.create(:section, name: "A").id
      ) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Manager by First Name" do
        correct_manager = FactoryBot.create(:manager, employee_id: FactoryBot.create(:employee, first_name: "C").id)
        managers = Manager.search(keywords: "C")
        expect(managers.map(&:id)).to contain_exactly(correct_manager.id)
      end

      it "finds the correct Manager by Last Name" do
        correct_manager = FactoryBot.create(:manager, employee_id: FactoryBot.create(:employee, last_name: "C").id)
        managers = Manager.search(keywords: "C")
        expect(managers.map(&:id)).to contain_exactly(correct_manager.id)
      end

      it "finds the correct Manager by Full Name" do
        correct_manager = FactoryBot.create(:manager,
          employee_id: FactoryBot.create(:employee, first_name: "C", last_name: "D").id)
        managers = Manager.search(keywords: "C D")
        expect(managers.map(&:id)).to contain_exactly(correct_manager.id)
      end

      it "finds the correct Manager by Section name" do
        correct_manager = FactoryBot.create(:manager,
          section_id: FactoryBot.create(:section, name: "C").id)
        managers = Manager.search(keywords: "C")
        expect(managers.map(&:id)).to contain_exactly(correct_manager.id)
      end
    end
  end
end
