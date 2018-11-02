class Section < ApplicationRecord
  has_many :employees
  has_many :jobs
  has_many :supervisors
  has_many :labor_records
  has_one :manager

  def get_removal_confirmation
    confirmation = "Performing this removal will also delete: \n"

    if !(self.jobs.nil?)
      confirmation << "* #{self.jobs.count} Job records, including: \n"
      job_labor_records = 0
      job_creditor_orders = 0
      job_debtor_orders = 0

      job_creditor_orders_payments = 0
      job_debtor_orders_payments = 0

      self.jobs.each do |job|
        job_labor_records += job.labor_records.count unless job.labor_records.nil?
        unless job.creditor_orders.nil?
          job_creditor_orders += job.creditor_orders.count
          job.creditor_orders.each do |creditor_order|
            job_creditor_orders_payments += creditor_order.credit_notes.count unless creditor_order.credit_notes.nil?
          end
        end

        unless job.debtor_orders.nil?
          job_debtor_orders += job.debtor_orders.count
          job.debtor_orders.each do |debtor_order|
            job_debtor_orders_payments += debtor_order.debtor_payments.count unless debtor_order.debtor_payments.nil?
          end
        end
      end

      confirmation << "  * #{job_labor_records} Labor Records from Jobs \n"
      confirmation << "  * #{job_creditor_orders} Creditor Order records from Jobs, including: \n"
      confirmation << "    * #{job_creditor_orders_payments} Creditor Payment records from Creditor Orders \n"
      confirmation << "  * #{job_debtor_orders} Debtor Order records from Jobs, including: \n"
      confirmation << "    * #{job_debtor_orders_payments} Debtor Payment records from Debtor Orders \n"

    end
    if !(self.employees.nil?)
      confirmation << "* #{self.employees.count} Employee records, including: \n"
      employee_labor_records_count_total = 0
      employee_managers_count_total = 0
      self.employees.each do |employee|
        employee_labor_records_count_total += employee.labor_records.count unless employee.labor_records.nil?
      end
      confirmation << "  * #{employee_labor_records_count_total} Labor Records from the Employees \n"
    end
    confirmation << "* 1 Manager record \n" unless self.manager.nil?
    confirmation << "* #{self.labor_records.count} Other Labor Records \n" unless self.labor_records.nil?
    confirmation << "Are you sure?"
  end

  def section_name
    "#{name}"
  end

  def self.search(keywords)

    search_term = keywords.downcase + '%'

    where_term = %{
      lower(name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "name asc"

    Section.where(where_term, search_term).order(order_term)
  end

end
