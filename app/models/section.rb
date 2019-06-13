class Section < ApplicationRecord
  has_many :employees
  has_many :jobs
  has_many :supervisors
  has_many :labor_records
  has_one :manager

  validates :name, :overheads, presence: true
  validates :overheads, numericality: { greater_than_or_equal_to: 0.0 }
  # sections
  # 	-> jobs
  # 		-> creditor_orders
  # 			-> credit_notes
  # 		-> debtor_orders
  # 			-> debtor_payments
  # 		-> labor_records
  # 	-> employees
  # 		-> managers
  # 		-> labor_records
  # 	-> managers
  # 	-> labor_records


  def self.jobs(section_id)
    Job.where(section_id: section_id)
  end

  def self.creditor_orders(job_ids)
    CreditorOrder.where("creditor_orders.job_id IN (?)", job_ids)
  end

  def self.credit_notes(creditor_order_ids)
    CreditNote.where("creditor_order_id IN (?)", creditor_order_ids)
  end

  def self.debtor_orders(job_ids)
    DebtorOrder.where("job_id IN (?)", job_ids)
  end

  def self.debtor_payments(debtor_order_ids)
    DebtorPayment.where("debtor_order_id IN (?)", debtor_order_ids)
  end

  def self.job_labor_records(job_ids)
    LaborRecord.where("job_id IN (?)", job_ids)
  end

  def self.employees(section_id)
    Employee.where(section_id: section_id)
  end

  def self.employee_managers(employee_ids)
    Manager.where("employee_id IN (?)", employee_ids)
  end

  def self.employee_labor_records(employee_ids)
    LaborRecord.where("employee_id IN (?)", employee_ids)
  end

  def self.manager(section_id)
    Section.find_by(id: section_id).manager
  end

  def self.section_labor_records(section_id)
    LaborRecord.where(section_id: section_id)
  end

  def self.entities(section_id)
    jobs                    = get_jobs(                   section_id          )
    creditor_orders         = get_creditor_orders(        jobs.ids            )
    credit_notes            = get_credit_notes(           creditor_orders.ids )
    debtor_orders           = get_debtor_orders(          jobs.ids            )
    debtor_payments         = get_debtor_payments(        debtor_orders.ids   )
    job_labor_records       = get_job_labor_records(      jobs.ids            )
    employees               = get_employees(              section_id          )
    employee_managers       = get_employee_managers(      employees.ids       )
    employee_labor_records  = get_employee_labor_records( employees.ids       )
    manager                 = get_manager(                section_id          )
    section_labor_records   = get_section_labor_records(  section_id          )

    manager.nil? ? manager_count = 0 : manager_count = 1
    {
      jobs: jobs,
      creditor_orders: creditor_orders,
      credit_notes: credit_notes,
      debtor_orders: debtor_orders,
      debtor_payments: debtor_payments,
      job_labor_records: job_labor_records,
      employees: employees,
      employee_managers: employee_managers,
      employee_labor_records: employee_labor_records,
      manager_count: manager_count,
      section_labor_records: section_labor_records
    }

  end

  def self.removal_confirmation(section_id)
    entities = get_entities(section_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:jobs].count} Job records \n"
    confirmation << "    * #{entities[:creditor_orders].count} Creditor Order records \n"
    confirmation << "        * #{entities[:credit_notes].count} Creditor Payment records \n"
    confirmation << "    * #{entities[:debtor_orders].count} Debtor Order records \n"
    confirmation << "        * #{entities[:debtor_payments].count} Debtor Payment records \n"
    confirmation << "    * #{entities[:job_labor_records].count} Labor Records related to Jobs \n"
    confirmation << "* #{entities[:employees].count} Employee records \n"
    confirmation << "    * #{entities[:employee_managers].count} Manager records \n"
    confirmation << "    * #{entities[:employee_labor_records].count} Labor Records related to Employees \n"
    confirmation << "* #{entities[:manager_count]} Manager records \n"
    confirmation << "* #{entities[:section_labor_records].count} Labor Records related to the Section \n"

    confirmation << "Are you sure?"
  end

  def section_name
    "#{name}"
  end

  def self.search(keywords)

    search_term = '%' + keywords.downcase + '%'

    where_term = %{
      lower(name) LIKE ?
    }.gsub(/\s+/, " ").strip

    order_term = "name asc"

    Section.where(where_term, search_term).order(order_term)
  end

end
