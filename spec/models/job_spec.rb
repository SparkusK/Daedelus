require 'rails_helper'

RSpec.describe Job, type: :model do
  after(:all) { DatabaseCleaner.clean_with(:truncation) }

  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_job = FactoryBot.create(:incorrect_job) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct job by Section name" do
        section = FactoryBot.create(:sample_section, name: "C")
        correct_job = FactoryBot.create(:correct_job, section_id: section.id)
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Contact Person" do
        correct_job = FactoryBot.create(:correct_job, contact_person: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Responsible Person" do
        correct_job = FactoryBot.create(:correct_job, responsible_person: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Work Description" do
        correct_job = FactoryBot.create(:correct_job, work_description: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Quotation Reference" do
        correct_job = FactoryBot.create(:correct_job, quotation_reference: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by JCE Number" do
        correct_job = FactoryBot.create(:correct_job, jce_number: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Job ID" do
        correct_job = FactoryBot.create(:correct_job)
        jobs = Job.search(keywords: "#{correct_job.id}")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Job Number" do
        correct_job = FactoryBot.create(:correct_job, job_number: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Order Number" do
        correct_job = FactoryBot.create(:correct_job, order_number: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end

      it "finds the correct job by Client Section" do
        correct_job = FactoryBot.create(:correct_job, client_section: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs).to contain_exactly(correct_job)
      end
    end

    context "with only target status filters" do
      before(:all) do
        @not_targeted_job = FactoryBot.create(:correct_job, total: 1000)
        @under_targeted_job = FactoryBot.create(:correct_job, total: 1000)
        FactoryBot.create(:correct_job_target, target_amount: 500, job_id: @under_targeted_job.id)
        @fully_targeted_job = FactoryBot.create(:correct_job, total: 1000)
        FactoryBot.create(:correct_job_target, target_amount: 1000, job_id: @fully_targeted_job.id)
        @over_targeted_job = FactoryBot.create(:correct_job, total: 1000)
        FactoryBot.create(:correct_job_target, target_amount: 1500, job_id: @over_targeted_job.id)
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct records when unfiltered" do
        jobs = Job.search(targets: "All")
        expect(jobs.map(&:id)).to contain_exactly(@not_targeted_job.id, @under_targeted_job.id, @fully_targeted_job.id, @over_targeted_job.id)
      end

      it "finds the correct records when not targeted" do
        jobs = Job.search(targets: "Not Targeted")
        expect(jobs.map(&:id)).to contain_exactly(@not_targeted_job.id)
      end

      it "finds the correct records when under targeted" do
        jobs = Job.search(targets: "Under Targeted")
        expect(jobs.map(&:id)).to contain_exactly(@under_targeted_job.id)
      end

      it "finds the correct records when fully targeted" do
        jobs = Job.search(targets: "Fully Targeted")
        expect(jobs.map(&:id)).to contain_exactly(@fully_targeted_job.id)
      end

      it "finds the correct records when over targeted" do
        jobs = Job.search(targets: "Over Targeted")
        expect(jobs.map(&:id)).to contain_exactly(@over_targeted_job.id)
      end
    end

    context "with only date filters" do
      before(:all) do
        @completed_job = FactoryBot.create(:correct_job, is_finished: "t")
        @incompleted_job = FactoryBot.create(:correct_job, is_finished: "f")
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }
      
      it "finds the correct records that start after a certain date" do

      end

      it "finds the correct records that start before a certain date" do

      end

      it "finds the correct records that end after a certain date" do

      end

      it "finds the correct records that end before a certain date" do

      end
    end

    context "with only completion filters" do
      before(:all) do
        @completed_job = FactoryBot.create(:correct_job, is_finished: "t")
        @incompleted_job = FactoryBot.create(:correct_job, is_finished: "f")
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds all records when not specified" do
        jobs = Job.search(completes: "All")
        expect(jobs.map(&:id)).to contain_exactly(@completed_job.id, @incompleted_job.id)
      end

      it "finds the correct records when Not Finished is selected" do
        jobs = Job.search(completes: "Not finished")
        expect(jobs.map(&:id)).to contain_exactly(@incompleted_job.id)
      end

      it "finds the correct records when Finished is selected" do
        jobs = Job.search(completes: "Finished")
        expect(jobs.map(&:id)).to contain_exactly(@completed_job.id)
      end
    end
  end

end
