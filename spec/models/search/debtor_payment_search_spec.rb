require 'rails_helper'

RSpec.describe DebtorPayment, type: :model do
  describe "search" do
    context "with only keywords" do
      before(:all) { incorrect_debtor_payment = FactoryBot.create(:debtor_payment,
        payment_type: "B", note: "B", invoice_code: "B",
        customer_id: FactoryBot.create(:customer, name: "B")) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Debtor Payment by its customer's name" do
        correct_debtor_payment = FactoryBot.create(:debtor_payment,
          customer_id: FactoryBot.create(:customer, name: "C").id)
        debtor_payments = DebtorPayment.search(keywords: "C")
        expect(debtor_payments.map(&:id)).to contain_exactly(correct_debtor_payment.id)
      end

      it "finds the correct Debtor Payment by payment type" do
        correct_debtor_payment = FactoryBot.create(:debtor_payment, payment_type: "C")
        debtor_payments = DebtorPayment.search(keywords: "C")
        expect(debtor_payments.map(&:id)).to contain_exactly(correct_debtor_payment.id)
      end

      it "finds the correct Debtor Payment by note" do
        correct_debtor_payment = FactoryBot.create(:debtor_payment, note: "C")
        debtor_payments = DebtorPayment.search(keywords: "C")
        expect(debtor_payments.map(&:id)).to contain_exactly(correct_debtor_payment.id)
      end

      it "finds the correct Debtor Payment by invoice code" do
        correct_debtor_payment = FactoryBot.create(:debtor_payment, invoice_code: "C")
        debtor_payments = DebtorPayment.search(keywords: "C")
        expect(debtor_payments.map(&:id)).to contain_exactly(correct_debtor_payment.id)
      end
    end

    context "with only payment start date" do
      before(:all) { incorrect_debtor_payment = FactoryBot.create(:debtor_payment, payment_date: 1.week.ago) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Debtor Payment when a Start Date is specified" do
        correct_debtor_payment = FactoryBot.create(:debtor_payment)
        debtor_payments = DebtorPayment.search(payment_dates: Utility::DateRange.new(start_date: Date.today))
        expect(debtor_payments.map(&:id)).to contain_exactly(correct_debtor_payment.id)
      end
    end

    context "with only payment end date" do
      before(:all) { incorrect_debtor_payment = FactoryBot.create(:debtor_payment, payment_date: 1.week.after) }
      after(:all) { DatabaseCleaner.clean_with(:deletion) }

      it "finds the correct Debtor Payment when an End Date is specified" do
        correct_debtor_payment = FactoryBot.create(:debtor_payment)
        debtor_payments = DebtorPayment.search(payment_dates: Utility::DateRange.new(end_date: Date.today))
        expect(debtor_payments.map(&:id)).to contain_exactly(correct_debtor_payment.id)
      end
    end

  end
end
