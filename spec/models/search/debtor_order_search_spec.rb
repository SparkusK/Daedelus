require 'rails_helper'

RSpec.describe DebtorOrder, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_debtor_order = FactoryBot.create(:debtor_order,
        customer_id: FactoryBot.create(:customer,
          phone: "B", name: "B", email: "B").id,
        job_id: FactoryBot.create(:job,
          jce_number: "B", contact_person: "B", responsible_person: "B").id,
        order_number: "B") }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Debtor Order by customer's phone number" do
        correct_debtor_order = FactoryBot.create(:debtor_order,
          customer_id: FactoryBot.create(:customer, phone: "C").id)
        debtor_orders = DebtorOrder.search(keywords: "C")
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end

      it "finds the correct Debtor Order by customer's name" do
        correct_debtor_order = FactoryBot.create(:debtor_order,
          customer_id: FactoryBot.create(:customer, name: "C").id)
        debtor_orders = DebtorOrder.search(keywords: "C")
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end

      it "finds the correct Debtor Order by customer's email" do
        correct_debtor_order = FactoryBot.create(:debtor_order,
          customer_id: FactoryBot.create(:customer, email: "C").id)
        debtor_orders = DebtorOrder.search(keywords: "C")
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end

      it "finds the correct Debtor Order by its Job's jce_number" do
        correct_job = FactoryBot.create(:job, jce_number: "C")
        correct_debtor_order = FactoryBot.create(:debtor_order, job_id: correct_job.id)
        debtor_orders = DebtorOrder.search(keywords: "C")
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end

      it "finds the correct Debtor Order by its Job's contact person" do
        correct_job = FactoryBot.create(:job, contact_person: "C")
        correct_debtor_order = FactoryBot.create(:debtor_order, job_id: correct_job.id)
        debtor_orders = DebtorOrder.search(keywords: "C")
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end

      it "finds the correct Debtor Order by its Job's responsible person" do
        correct_job = FactoryBot.create(:job, responsible_person: "C")
        correct_debtor_order = FactoryBot.create(:debtor_order, job_id: correct_job.id)
        debtor_orders = DebtorOrder.search(keywords: "C")
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end

      it "finds the correct Debtor Order by its order number" do
        correct_debtor_order = FactoryBot.create(:debtor_order, order_number: "C")
        debtor_orders = DebtorOrder.search(keywords: "C")
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end
    end

    context "with only updated start date" do
      before(:all) { incorrect_debtor_order = FactoryBot.create(:debtor_order).update_attributes(updated_at: 1.week.ago) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Debtor Order when a Start Date is specified" do
        correct_debtor_order = FactoryBot.create(:debtor_order)
        debtor_orders = DebtorOrder.search(target_dates: Utility::DateRange.new(start_date: Date.today))
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end
    end

    context "with only updated end date" do
      before(:all) { incorrect_debtor_order = FactoryBot.create(:debtor_order).update_attributes(updated_at: 1.week.after) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Debtor Order when an End Date is specified" do
        correct_debtor_order = FactoryBot.create(:debtor_order)
        debtor_orders = DebtorOrder.search(target_dates: Utility::DateRange.new(end_date: Date.today))
        expect(debtor_orders.map(&:id)).to contain_exactly(correct_debtor_order.id)
      end
    end
  end
end
