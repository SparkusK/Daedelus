class ChangeRestrictionsOnTables < ActiveRecord::Migration[5.1]
  def change
    # Foreign keys are automatically validated for referential integrity.

    # -- EMPLOYEES --
    change_column_null :employees, :first_name, false
    change_column_null :employees, :last_name, false
    change_column_null :employees, :occupation, false
    change_column_null :employees, :company_number, false
    change_column_null :employees, :eoc, false, false
    change_column_default :employees, :eoc, false
    change_column_null :employees, :net_rate, false
    change_column_null :employees, :inclusive_rate, false

    # -- SECTIONS --
    change_column_null :sections, :name, false
    change_column_null :sections, :overheads, false

    # -- JOBS --
    change_column_null :jobs, :receive_date, false
    change_column_null :jobs, :target_date, false
    change_column_null :jobs, :contact_person, false
    change_column_null :jobs, :responsible_person, false
    change_column_null :jobs, :work_description, false
    change_column_null :jobs, :jce_number, false
    change_column_null :jobs, :quotation_reference, false
    change_column_null :jobs, :total, false
    change_column_null :jobs, :targeted_amount, false

    # -- LABOR RECORDS --
    change_column_null :labor_records, :labor_date, false
    change_column_null :labor_records, :hours, false
    change_column_null :labor_records, :normal_time_amount_before_tax, false
    change_column_null :labor_records, :overtime_amount_before_tax, false
    change_column_null :labor_records, :sunday_time_amount_before_tax, false
    change_column_null :labor_records, :normal_time_amount_after_tax, false
    change_column_null :labor_records, :overtime_amount_after_tax, false
    change_column_null :labor_records, :sunday_time_amount_after_tax, false

    # -- CUSTOMERS --
    change_column_null :customers, :name, false

    # -- SUPPLIERS --
    change_column_null :suppliers, :name, false

    # -- DEBTOR ORDERS --
    change_column_null :debtor_orders, :order_number, false
    change_column_null :debtor_orders, :value_including_tax, false
    change_column_null :debtor_orders, :tax_amount, false
    change_column_null :debtor_orders, :value_excluding_tax, false

    # -- DEBTOR PAYMENTS --
    change_column_null :debtor_payments, :payment_date, false
    change_column_null :debtor_payments, :payment_amount, false
    change_column_null :debtor_payments, :payment_type, false
    change_column_null :debtor_payments, :invoice_code, false

    # -- CREDITOR ORDERS --
    change_column_null :creditor_orders, :date_issued, false
    change_column_null :creditor_orders, :value_excluding_tax, false
    change_column_null :creditor_orders, :tax_amount, false
    change_column_null :creditor_orders, :value_including_tax, false
    change_column_null :creditor_orders, :reference_number, false

    # -- CREDITOR PAYMENTS --
    change_column_null :credit_notes, :invoice_code, false
    change_column_null :credit_notes, :amount_paid, false
    change_column_null :credit_notes, :payment_type, false
  end
end
