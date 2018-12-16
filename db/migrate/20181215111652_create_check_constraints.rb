class CreateCheckConstraints < ActiveRecord::Migration[5.1]
  def up


    execute %{

      -- EMPLOYEES -----------

      ALTER TABLE
        employees
      ADD CONSTRAINT
        net_rate_positive
      CHECK( net_rate >= 0.0 );

      ALTER TABLE
        employees
      ADD CONSTRAINT
        inclusive_rate_positive
      CHECK( inclusive_rate >= 0.0 );

      ALTER TABLE
        employees
      ADD CONSTRAINT
        net_rate_less_than_inclusive_rate
      CHECK( net_rate < inclusive_rate );

      -- SECTIONS -----------

      ALTER TABLE
        sections
      ADD CONSTRAINT
        overheads_positive
      CHECK( overheads >= 0.0 );

      -- JOBS -----------

      ALTER TABLE
        jobs
      ADD CONSTRAINT
        total_positive
      CHECK( total > 0.0 );

      ALTER TABLE
        jobs
      ADD CONSTRAINT
        targeted_amount_positive
      CHECK( targeted_amount >= 0.0 );

      ALTER TABLE
        jobs
      ADD CONSTRAINT
        targeted_amount_lte_total
      CHECK( targeted_amount <= total );

      -- LABOR_RECORDS -----------

      ALTER TABLE
        labor_records
      ADD CONSTRAINT
        hours_between_0_and_24
      CHECK( hours >= 0.0 AND hours <= 24.0 );

      ALTER TABLE
        labor_records
      ADD CONSTRAINT
        normal_time_amount_before_tax_positive
      CHECK( normal_time_amount_before_tax >= 0.0 );

      ALTER TABLE
        labor_records
      ADD CONSTRAINT
        normal_time_amount_after_tax_positive
      CHECK( normal_time_amount_after_tax >= 0.0 );

      ALTER TABLE
        labor_records
      ADD CONSTRAINT
        overtime_amount_before_tax_positive
      CHECK( overtime_amount_before_tax >= 0.0 );

      ALTER TABLE
        labor_records
      ADD CONSTRAINT
        overtime_amount_after_tax_positive
      CHECK( overtime_amount_after_tax >= 0.0 );

      ALTER TABLE
        labor_records
      ADD CONSTRAINT
        sunday_time_amount_before_tax_positive
      CHECK( sunday_time_amount_before_tax >= 0.0 );

      ALTER TABLE
        labor_records
      ADD CONSTRAINT
        sunday_time_amount_after_tax_positive
      CHECK( sunday_time_amount_after_tax >= 0.0 );

      -- DEBTOR_ORDERS -----------

      ALTER TABLE
        debtor_orders
      ADD CONSTRAINT
        value_excluding_tax_positive
      CHECK( value_excluding_tax >= 0.0 );

      ALTER TABLE
        debtor_orders
      ADD CONSTRAINT
        tax_amount_positive
      CHECK( tax_amount >= 0.0 );

      ALTER TABLE
        debtor_orders
      ADD CONSTRAINT
        value_including_tax_positive
      CHECK( value_including_tax >= 0.0 );

      ALTER TABLE
        debtor_orders
      ADD CONSTRAINT
        value_incl_lt_value_excl
      CHECK( value_including_tax < value_excluding_tax );

      ALTER TABLE
        debtor_orders
      ADD CONSTRAINT
        tax_amount_lt_value_incl
      CHECK( tax_amount < value_including_tax );

      -- DEBTOR_PAYMENTS -----------

      ALTER TABLE
        debtor_payments
      ADD CONSTRAINT
        payment_amount_positive
      CHECK( payment_amount >= 0.0 );

      -- CREDITOR_ORDERS -----------

      ALTER TABLE
        creditor_orders
      ADD CONSTRAINT
        value_including_tax_positive
      CHECK( value_including_tax >= 0.0 );

      ALTER TABLE
        creditor_orders
      ADD CONSTRAINT
        tax_amount_positive
      CHECK( tax_amount >= 0.0 );

      ALTER TABLE
        creditor_orders
      ADD CONSTRAINT
        value_excluding_tax_positive
      CHECK( value_excluding_tax >= 0.0 );

      ALTER TABLE
        creditor_orders
      ADD CONSTRAINT
        value_incl_lt_value_excl
      CHECK( value_including_tax < value_excluding_tax );

      ALTER TABLE
        creditor_orders
      ADD CONSTRAINT
        tax_amount_lt_value_incl
      CHECK( tax_amount < value_including_tax );

      -- CREDIT_NOTES -----------

      ALTER TABLE
        credit_notes
      ADD CONSTRAINT
        amount_paid_positive
      CHECK( amount_paid >= 0.0 );

    }
  end

  def down
    execute %{

      -- EMPLOYEES -----------

      ALTER TABLE
        employees
      DROP CONSTRAINT
        net_rate_positive;

      ALTER TABLE
        employees
      DROP CONSTRAINT
        inclusive_rate_positive;

      ALTER TABLE
        employees
      DROP CONSTRAINT
        net_rate_greater_than_inclusive_rate;

      -- SECTIONS -----------

      ALTER TABLE
        sections
      DROP CONSTRAINT
        overheads_positive;

      -- JOBS -----------

      ALTER TABLE
        jobs
      DROP CONSTRAINT
        total_positive;

      ALTER TABLE
        jobs
      DROP CONSTRAINT
        targeted_amount_positive;

      ALTER TABLE
        jobs
      DROP CONSTRAINT
        targeted_amount_lte_total;

      -- LABOR_RECORDS -----------

      ALTER TABLE
        labor_records
      DROP CONSTRAINT
        hours_between_0_and_24;

      ALTER TABLE
        labor_records
      DROP CONSTRAINT
        normal_time_amount_before_tax_positive;

      ALTER TABLE
        labor_records
      DROP CONSTRAINT
        normal_time_amount_after_tax_positive;

      ALTER TABLE
        labor_records
      DROP CONSTRAINT
        overtime_amount_before_tax_positive;

      ALTER TABLE
        labor_records
      DROP CONSTRAINT
        overtime_amount_after_tax_positive;

      ALTER TABLE
        labor_records
      DROP CONSTRAINT
        sunday_time_amount_before_tax_positive;

      ALTER TABLE
        labor_records
      DROP CONSTRAINT
        sunday_time_amount_after_tax_positive;

      -- DEBTOR_ORDERS -----------

      ALTER TABLE
        debtor_orders
      DROP CONSTRAINT
        value_excluding_tax_positive;

      ALTER TABLE
        debtor_orders
      DROP CONSTRAINT
        tax_amount_positive

      ALTER TABLE
        debtor_orders
      DROP CONSTRAINT
        value_including_tax_positive;

      ALTER TABLE
        debtor_orders
      DROP CONSTRAINT
        value_incl_lt_value_excl;

      ALTER TABLE
        debtor_orders
      DROP CONSTRAINT
        tax_amount_lt_value_incl;

      -- DEBTOR_PAYMENTS -----------

      ALTER TABLE
        debtor_payments
      DROP CONSTRAINT
        payment_amount_positive;

      -- CREDITOR_ORDERS -----------

      ALTER TABLE
        creditor_orders
      DROP CONSTRAINT
        value_including_tax_positive;

      ALTER TABLE
        creditor_orders
      DROP CONSTRAINT
        tax_amount_positive

      ALTER TABLE
        creditor_orders
      DROP CONSTRAINT
        value_excluding_tax_positive;

      ALTER TABLE
        creditor_orders
      DROP CONSTRAINT
        value_incl_lt_value_excl;

      ALTER TABLE
        creditor_orders
      DROP CONSTRAINT
        tax_amount_lt_value_incl;

      -- CREDIT_NOTES -----------

      ALTER TABLE
        credit_notes
      DROP CONSTRAINT
        amount_paid_positive;

    }
  end
end
