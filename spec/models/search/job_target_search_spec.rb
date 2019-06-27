require 'rails_helper'

RSpec.describe JobTarget, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_job_target = FactoryBot.create(:job_target,
        remarks: "B", invoice_number: "B", details: "B") }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Job Target by invoice number" do
        correct_job_target = FactoryBot.create(:job_target, invoice_number: "C")
        job_targets = JobTarget.search(keywords: "C")
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end

      it "finds the correct Job Target by remarks" do
        correct_job_target = FactoryBot.create(:job_target, remarks: "C")
        job_targets = JobTarget.search(keywords: "C")
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end

      it "finds the correct Job Target by details" do
        correct_job_target = FactoryBot.create(:job_target, details: "C")
        job_targets = JobTarget.search(keywords: "C")
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end

      it "finds the correct Job Target by its Job's jce_number" do
        correct_job = FactoryBot.create(:job, jce_number: "C")
        correct_job_target = FactoryBot.create(:job_target, job_id: correct_job.id)
        job_targets = JobTarget.search(keywords: "C")
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end

      it "finds the correct Job Target by its Job's job_number" do
        correct_job = FactoryBot.create(:job, job_number: "C")
        correct_job_target = FactoryBot.create(:job_target, job_id: correct_job.id)
        job_targets = JobTarget.search(keywords: "C")
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end

      it "finds the correct Job Target by its Section's name" do
        correct_section = FactoryBot.create(:section, name: "C")
        correct_job_target = FactoryBot.create(:job_target, section_id: correct_section.id)
        job_targets = JobTarget.search(keywords: "C")
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end
    end

    context "with only target start date" do
      before(:all) { incorrect_job_target = FactoryBot.create(:job_target, target_date: 1.week.ago) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Job Target when a Start Date is specified" do
        correct_job_target = FactoryBot.create(:job_target)
        job_targets = JobTarget.search(target_dates: Utility::DateRange.new(start_date: Date.today))
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end
    end

    context "with only target end date" do
      before(:all) { incorrect_job_target = FactoryBot.create(:job_target, target_date: 1.week.after) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Job Target when an End Date is specified" do
        correct_job_target = FactoryBot.create(:job_target)
        job_targets = JobTarget.search(target_dates: Utility::DateRange.new(end_date: Date.today))
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end
    end

    context "with only section id filter" do
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "Filters the correct job target by section_id" do
        correct_section_id = FactoryBot.create(:section).id
        incorrect_section_id = FactoryBot.create(:section).id
        correct_job_target = FactoryBot.create(:job_target, section_id: correct_section_id)
        incorrect_job_target = FactoryBot.create(:job_target, section_id: incorrect_section_id)
        job_targets = JobTarget.search(section_filter_id: "#{correct_section_id}")
        expect(job_targets.map(&:id)).to contain_exactly(correct_job_target.id)
      end
    end
  end
end
