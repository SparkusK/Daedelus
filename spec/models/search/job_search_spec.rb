
require 'rails_helper'

RSpec.describe Job, type: :model do

  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_job = FactoryBot.create(:incorrect_job) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct job by Section name" do
        section = FactoryBot.create(:sample_section, name: "C")
        correct_job = FactoryBot.create(:job, section_id: section.id)
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Contact Person" do
        correct_job = FactoryBot.create(:job, contact_person: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Responsible Person" do
        correct_job = FactoryBot.create(:job, responsible_person: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Work Description" do
        correct_job = FactoryBot.create(:job, work_description: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Quotation Reference" do
        correct_job = FactoryBot.create(:job, quotation_reference: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by JCE Number" do
        correct_job = FactoryBot.create(:job, jce_number: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Job ID" do
        correct_job = FactoryBot.create(:job)
        jobs = Job.search(keywords: "#{correct_job.id}")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Job Number" do
        correct_job = FactoryBot.create(:job, job_number: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Order Number" do
        correct_job = FactoryBot.create(:job, order_number: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end

      it "finds the correct job by Client Section" do
        correct_job = FactoryBot.create(:job, client_section: "C")
        jobs = Job.search(keywords: "C")
        expect(jobs.map(&:id)).to contain_exactly(correct_job.id)
      end
    end

    context "with only target status filters" do
      before(:all) do
        @not_targeted_job = FactoryBot.create(:job, total: 1000)
        @under_targeted_job = FactoryBot.create(:job, total: 1000)
        FactoryBot.create(:job_target, target_amount: 500, job_id: @under_targeted_job.id)
        @fully_targeted_job = FactoryBot.create(:job, total: 1000)
        FactoryBot.create(:job_target, target_amount: 1000, job_id: @fully_targeted_job.id)
        @over_targeted_job = FactoryBot.create(:job, total: 1000)
        FactoryBot.create(:job_target, target_amount: 1500, job_id: @over_targeted_job.id)
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct records when unfiltered" do
        jobs = Job.search(targets: Search::Job::TargetComparisonEnum::ALL)
        expect(jobs.map(&:id)).to contain_exactly(@not_targeted_job.id, @under_targeted_job.id, @fully_targeted_job.id, @over_targeted_job.id)
      end

      it "finds the correct records when not targeted" do
        jobs = Job.search(targets: Search::Job::TargetComparisonEnum::NOT_TARGETED)
        expect(jobs.map(&:id)).to contain_exactly(@not_targeted_job.id)
      end

      it "finds the correct records when under targeted" do
        jobs = Job.search(targets: Search::Job::TargetComparisonEnum::UNDER_TARGETED)
        expect(jobs.map(&:id)).to contain_exactly(@under_targeted_job.id)
      end

      it "finds the correct records when fully targeted" do
        jobs = Job.search(targets: Search::Job::TargetComparisonEnum::FULLY_TARGETED)
        expect(jobs.map(&:id)).to contain_exactly(@fully_targeted_job.id)
      end

      it "finds the correct records when over targeted" do
        jobs = Job.search(targets: Search::Job::TargetComparisonEnum::OVER_TARGETED)
        expect(jobs.map(&:id)).to contain_exactly(@over_targeted_job.id)
      end
    end

    context "with only receive_date filters" do
      before(:all) do
        @date_range = Utility::DateRange.new(start_date: 1.day.ago, end_date: 1.day.after)
        @correct_job = FactoryBot.create(:job, receive_date: Date.today)
        @incorrect_job = FactoryBot.create(:job, receive_date: 3.days.ago)
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct records within a certain date range", :aggregate_failures do
        jobs = Job.search(receive_dates: @date_range)
        expect(jobs.map(&:id)).to contain_exactly(@correct_job.id)
        expect(jobs.map(&:id)).not_to contain_exactly(@incorrect_job.id)
      end
    end

    context "with only job_target_date filters" do
      before(:all) do
        @date_range = Utility::DateRange.new(start_date: Date.yesterday, end_date: Date.tomorrow)
        @job_inside = FactoryBot.create(:job)
        @job_inside_target = FactoryBot.create(:job_target,
          job_id: @job_inside.id, target_date: Date.today)
        @job_before = FactoryBot.create(:job)
        @job_before_target = FactoryBot.create(:job_target,
          job_id: @job_before.id, target_date: 7.days.ago)
        @job_after = FactoryBot.create(:job)
        @job_after_target = FactoryBot.create(:job_target,
          job_id: @job_after.id, target_date: 7.days.after)
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds and filters Jobs correctly via their Job Targets' Dates", :aggregate_failures do
        jobs = Job.search(target_dates: @date_range)
        expect(jobs.map(&:id)).to contain_exactly(@job_inside.id)
        expect(jobs.map(&:id)).not_to contain_exactly(@job_before.id, @job_after.id)
      end
    end

    context "with only section_id_filters" do
      before(:all) do
        @correct_section = FactoryBot.create(:sample_section, name: "Abc")
        @incorrect_section = FactoryBot.create(:sample_section, name: "Efg")
        @correct_job = FactoryBot.create(:job, section_id: @correct_section.id)
        @incorrect_job = FactoryBot.create(:job, section_id: @incorrect_section.id)
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds and filters the correct records via the section_id filter" do
        jobs = Job.search(section_filter_id: "#{@correct_section.id}")
        expect(jobs.map(&:id)).to contain_exactly(@correct_job.id)
        expect(jobs.map(&:id)).not_to contain_exactly(@incorrect_job.id)
      end
    end


    context "with only completion filters" do
      before(:all) do
        @completed_job = FactoryBot.create(:job, is_finished: "t")
        @incompleted_job = FactoryBot.create(:job, is_finished: "f")
      end

      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds all records when not specified" do
        jobs = Job.search(completes: Search::Job::CompletionStatusEnum::ALL)
        expect(jobs.map(&:id)).to contain_exactly(@completed_job.id, @incompleted_job.id)
      end

      it "finds the correct records when Not Finished is selected" do
        jobs = Job.search(completes: Search::Job::CompletionStatusEnum::NOT_FINISHED)
        expect(jobs.map(&:id)).to contain_exactly(@incompleted_job.id)
      end

      it "finds the correct records when Finished is selected" do
        jobs = Job.search(completes: Search::Job::CompletionStatusEnum::FINISHED)
        expect(jobs.map(&:id)).to contain_exactly(@completed_job.id)
      end
    end
  end
end
