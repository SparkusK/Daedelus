require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_employee = FactoryBot.create(:incorrect_employee) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Employee via its First Name" do
        correct_employee = FactoryBot.create(:employee, first_name: "C")
        employees = Employee.search(keywords: "C")
        expect(employees.map(&:id)).to contain_exactly(correct_employee.id)
      end

      it "finds the correct Employee via its Last Name" do
        correct_employee = FactoryBot.create(:employee, last_name: "C")
        employees = Employee.search(keywords: "C")
        expect(employees.map(&:id)).to contain_exactly(correct_employee.id)
      end

      it "finds the correct Employee via its Full Name" do
        correct_employee = FactoryBot.create(:employee, first_name: "C", last_name: "D")
        employees = Employee.search(keywords: "C D")
        expect(employees.map(&:id)).to contain_exactly(correct_employee.id)
      end

      it "finds the correct Employee via its Occupation" do
        correct_employee = FactoryBot.create(:employee, occupation: "C")
        employees = Employee.search(keywords: "C")
        expect(employees.map(&:id)).to contain_exactly(correct_employee.id)
      end

      it "finds the correct Employee via its Section's Name" do
        correct_employee = FactoryBot.create(:employee, section_id: FactoryBot.create(:section, name: "C").id)
        employees = Employee.search(keywords: "C")
        expect(employees.map(&:id)).to contain_exactly(correct_employee.id)
      end

      it "finds the correct Employee via its Company Number" do
        correct_employee = FactoryBot.create(:employee, company_number: "C")
        employees = Employee.search(keywords: "C")
        expect(employees.map(&:id)).to contain_exactly(correct_employee.id)
      end
    end
  end
end
