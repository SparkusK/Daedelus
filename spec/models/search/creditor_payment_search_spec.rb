require 'rails_helper'

RSpec.describe CreditorPayment, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_creditor_payment = FactoryBot.create(:creditor_payment,
        creditor_order_id: FactoryBot.create(:creditor_order,
          job_id: FactoryBot.create(:job, jce_number: "B").id,
          supplier_id: FactoryBot.create(:supplier, name: "B").id,
         note: "B", payment_type: "B")) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Creditor Payment by its supplier's name" do
        correct_creditor_payment = FactoryBot.create(:creditor_payment, supplier_id:
          FactoryBot.create(:supplier, name: "C").id)
        creditor_payments = CreditorPayment.search(keywords: "C")
        expect(creditor_payments.map(&:id)).to contain_exactly(correct_creditor_payment.id)
      end

      it "finds the correct Creditor Payment by its Job's jce_number" do
        correct_creditor_payment = FactoryBot.create(:creditor_payment, job_id:
          FactoryBot.create(:job, jce_number: "C").id)
        creditor_payments = CreditorPayment.search(keywords: "C")
        expect(creditor_payments.map(&:id)).to contain_exactly(correct_creditor_payment.id)
      end

      it "finds the correct Creditor Payment by payment type" do
        correct_creditor_payment = FactoryBot.create(:creditor_payment, payment_type: "C")
        creditor_payments = CreditorPayment.search(keywords: "C")
        expect(creditor_payments.map(&:id)).to contain_exactly(correct_creditor_payment.id)
      end

      it "finds the correct Creditor Payment by note" do
        correct_creditor_payment = FactoryBot.create(:creditor_payment, note: "C")
        creditor_payments = CreditorPayment.search(keywords: "C")
        expect(creditor_payments.map(&:id)).to contain_exactly(correct_creditor_payment.id)
      end
    end

    context "with only updated start date" do
      before(:all) { incorrect_creditor_payment = FactoryBot.create(:creditor_payment).update_attributes(updated_at: 1.week.ago) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Creditor Payment when a Start Date is specified" do
        correct_creditor_payment = FactoryBot.create(:creditor_payment)
        creditor_payments = CreditorPayment.search(updated_dates: Utility::DateRange.new(start_date: Date.today))
        expect(creditor_payments.map(&:id)).to contain_exactly(correct_creditor_payment.id)
      end
    end

    context "with only updated end date" do
      before(:all) { incorrect_creditor_payment = FactoryBot.create(:creditor_payment).update_attributes(updated_at: 1.week.after) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Creditor Payment when an End Date is specified" do
        correct_creditor_payment = FactoryBot.create(:creditor_payment)
        creditor_payments = CreditorPayment.search(updated_dates: Utility::DateRange.new(end_date: Date.today))
        expect(creditor_payments.map(&:id)).to contain_exactly(correct_creditor_payment.id)
      end
    end

  end
end
