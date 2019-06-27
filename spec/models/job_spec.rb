require 'rails_helper'

RSpec.describe Job, type: :model do
  describe "removal confirmation" do
    before(:all) do
      @job_to_delete = FactoryBot.create(:job)
      @creditor_order1 = FactoryBot.create(:creditor_order,
        job_id: @job_to_delete.id,
        value_excluding_tax: 2000.0, tax_amount: 400.0, value_including_tax: 2400.0)
      @creditor_order2 = FactoryBot.create(:creditor_order,
        job_id: @job_to_delete.id,
        value_excluding_tax: 2000.0, tax_amount: 400.0, value_including_tax: 2400.0)
      @creditor_payments = []
      2.times { @creditor_payments << FactoryBot.create(:creditor_payment,
        creditor_order_id: @creditor_order1.id, amount_paid: rand(500.0)) }
      2.times { @creditor_payments << FactoryBot.create(:creditor_payment,
        creditor_order_id: @creditor_order2.id, amount_paid: rand(500.0)) }
      @debtor_order1 = FactoryBot.create(:debtor_order,
        job_id: @job_to_delete.id,
        value_excluding_tax: 2000.0, tax_amount: 400.0, value_including_tax: 2400.0)
      @debtor_order2 = FactoryBot.create(:debtor_order,
        job_id: @job_to_delete.id,
        value_excluding_tax: 2000.0, tax_amount: 400.0, value_including_tax: 2400.0)
      @debtor_orders = []
      2.times { @debtor_orders << FactoryBot.create(:debtor_payment,
        debtor_order_id: @debtor_order1.id, payment_amount: rand(500.0)) }
      2.times { @debtor_orders << FactoryBot.create(:debtor_payment,
        debtor_order_id: @debtor_order2.id, payment_amount: rand(500.0)) }
      @labor_record1 = FactoryBot.create(:labor_record, job_id: @job_to_delete.id)
      @labor_record2 = FactoryBot.create(:labor_record, job_id: @job_to_delete.id)
      @job_target_1 = FactoryBot.create(:job_target, job_id: @job_to_delete.id)
      @job_target_2 = FactoryBot.create(:job_target, job_id: @job_to_delete.id)
    end

    after(:all) do
      DatabaseCleaner.clean_with(:deletion)
    end

    it "generates an accurate removal confirmation string", :aggregate_failures do
      removal_string = Job.removal_confirmation(@job_to_delete.id)
      expect(removal_string).to include("2 Creditor orders")
      expect(removal_string).to include("4 Creditor payments")
      expect(removal_string).to include("2 Debtor orders")
      expect(removal_string).to include("4 Debtor payments")
      expect(removal_string).to include("2 Labor records")
      expect(removal_string).to include("2 Job targets")
    end

  end
end
