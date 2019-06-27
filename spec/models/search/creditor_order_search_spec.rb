require 'rails_helper'

RSpec.describe CreditorOrder, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_creditor_order = FactoryBot.create(:creditor_order,
        job_id: FactoryBot.create(:job,
          jce_number: "B", contact_person: "B", responsible_person: "B").id,
        supplier_id: FactoryBot.create(:supplier,
          name: "B", email: "B", phone: "B").id,
         delivery_note: "B", reference_number: "B") }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Creditor Order by its supplier's phone" do
        correct_creditor_order = FactoryBot.create(:creditor_order, supplier_id:
          FactoryBot.create(:supplier, phone: "C").id)
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end

      it "finds the correct Creditor Order by its supplier's name" do
        correct_creditor_order = FactoryBot.create(:creditor_order, supplier_id:
          FactoryBot.create(:supplier, name: "C").id)
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end

      it "finds the correct Creditor Order by its supplier's email" do
        correct_creditor_order = FactoryBot.create(:creditor_order, supplier_id:
          FactoryBot.create(:supplier, email: "C").id)
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end

      it "finds the correct Creditor Order by its Job's jce_number" do
        correct_creditor_order = FactoryBot.create(:creditor_order, job_id:
          FactoryBot.create(:job, jce_number: "C").id)
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end

      it "finds the correct Creditor Order by its Job's contact person" do
        correct_creditor_order = FactoryBot.create(:creditor_order, job_id:
          FactoryBot.create(:job, contact_person: "C").id)
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end

      it "finds the correct Creditor Order by its Job's responsible person" do
        correct_creditor_order = FactoryBot.create(:creditor_order, job_id:
          FactoryBot.create(:job, responsible_perosn: "C").id)
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end

      it "finds the correct Creditor Order by delivery note" do
        correct_creditor_order = FactoryBot.create(:creditor_order, delivery_note: "C")
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end
      it "finds the correct Creditor Order by reference number" do
        correct_creditor_order = FactoryBot.create(:creditor_order, reference_number: "C")
        creditor_orders = CreditorOrder.search(keywords: "C")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end
    end

    context "with only target start date" do
      before(:all) { incorrect_creditor_order = FactoryBot.create(:creditor_order, date_issued: 1.week.ago) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Creditor Order when a Start Date is specified" do
        correct_creditor_order = FactoryBot.create(:creditor_order)
        creditor_orders = CreditorOrder.search(issued_dates: Utility::DateRange.new(start_date: Date.today))
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end
    end

    context "with only target end date" do
      before(:all) { incorrect_creditor_order = FactoryBot.create(:creditor_order, date_issued: 1.week.after) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Creditor Order when an End Date is specified" do
        correct_creditor_order = FactoryBot.create(:creditor_order)
        creditor_orders = CreditorOrder.search(issued_dates: Utility::DateRange.new(end_date: Date.today))
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end
    end

    context "with only section id filter" do
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "Filters the correct job target by section_id" do
        correct_section_id = FactoryBot.create(:section).id
        incorrect_section_id = FactoryBot.create(:section).id
        correct_creditor_order = FactoryBot.create(:creditor_order, section_id: correct_section_id)
        incorrect_creditor_order = FactoryBot.create(:creditor_order, section_id: incorrect_section_id)
        creditor_orders = CreditorOrder.search(section_filter_id: "#{correct_section_id}")
        expect(creditor_orders.map(&:id)).to contain_exactly(correct_creditor_order.id)
      end
    end
  end
end
