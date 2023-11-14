require 'rails_helper'

RSpec.describe LaborRecord, type: :model do
  describe "search" do
    context "with only keywords" do
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Labor Record by Employee First Name" do
        incorrect_employee = FactoryBot.create(:employee, first_name: "B")
        correct_employee = FactoryBot.create(:employee, first_name: "C")
        correct_labor_record = FactoryBot.create(:labor_record, employee_id: correct_employee.id)
        incorrect_labor_record = FactoryBot.create(:labor_record, employee_id: incorrect_employee.id)
        labor_records = LaborRecord.search(keywords: "C")
        expect(labor_records.map(&:id)).to contain_exactly(correct_labor_record.id)
      end

      it "finds the correct Labor Record by Employee Last Name" do
        incorrect_employee = FactoryBot.create(:employee, last_name: "B")
        correct_employee = FactoryBot.create(:employee, last_name: "C")
        correct_labor_record = FactoryBot.create(:labor_record, employee_id: correct_employee.id)
        incorrect_labor_record = FactoryBot.create(:labor_record, employee_id: incorrect_employee.id)
        labor_records = LaborRecord.search(keywords: "C")
        expect(labor_records.map(&:id)).to contain_exactly(correct_labor_record.id)
      end

      it "finds the correct Labor Record by Jobs JCE number" do
        incorrect_job = FactoryBot.create(:job, jce_number: "B")
        correct_job = FactoryBot.create(:job, jce_number: "C")
        correct_labor_record = FactoryBot.create(:labor_record, job_id: correct_job.id)
        incorrect_labor_record = FactoryBot.create(:labor_record, job_id: incorrect_job.id)
        labor_records = LaborRecord.search(keywords: "C")
        expect(labor_records.map(&:id)).to contain_exactly(correct_labor_record.id)
      end

      it "finds the correct Labor Record by its Job's Job Number" do
        incorrect_job = FactoryBot.create(:job, job_number: "B")
        correct_job = FactoryBot.create(:job, job_number: "C")
        correct_labor_record = FactoryBot.create(:labor_record, job_id: correct_job.id)
        incorrect_labor_record = FactoryBot.create(:labor_record, job_id: incorrect_job.id)
        labor_records = LaborRecord.search(keywords: "C")
        expect(labor_records.map(&:id)).to contain_exactly(correct_labor_record.id)
      end
    end

    context "with only labor start date" do
      before(:all) { incorrect_labor_record = FactoryBot.create(:labor_record, labor_date: 1.week.ago) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Labor Record when a Start Date is specified" do
        correct_labor_record = FactoryBot.create(:labor_record)
        labor_records = LaborRecord.search(labor_dates:  Utility::DateRange.new(start_date: Date.today))
        expect(labor_records.map(&:id)).to contain_exactly(correct_labor_record.id)
      end
    end

    context "with only labor end date" do
      before(:all) { incorrect_labor_record = FactoryBot.create(:labor_record, labor_date: 1.week.after) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Labor Record when an End Date is specified" do
        correct_labor_record = FactoryBot.create(:labor_record)
        labor_records = LaborRecord.search(labor_dates:  Utility::DateRange.new(end_date: Date.today))
        expect(labor_records.map(&:id)).to contain_exactly(correct_labor_record.id)
      end
    end

    context "with only section id filter" do
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "Filters the correct Labor Record by section_id" do
        correct_section_id = FactoryBot.create(:section).id
        incorrect_section_id = FactoryBot.create(:section).id
        correct_labor_record = FactoryBot.create(:labor_record, section_id: correct_section_id)
        incorrect_labor_record = FactoryBot.create(:labor_record, section_id: incorrect_section_id)
        labor_records = LaborRecord.search(section_filter_id: "#{correct_section_id}")
        expect(labor_records.map(&:id)).to contain_exactly(correct_labor_record.id)
      end
    end
  end
end
