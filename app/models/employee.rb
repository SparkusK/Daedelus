class Employee < ApplicationRecord
  include Searchable
  belongs_to :section
  has_many :labor_records, dependent: :delete_all
  has_one :manager

  validates :first_name, :last_name, :occupation, :company_number, presence: true
  validates :net_rate, :inclusive_rate, numericality: { greater_than_or_equal_to: 0.0 }
  validates :net_rate, numericality: { less_than: :inclusive_rate }

  def labor_records
    LaborRecord.where("employee_id = ?", self.id)
  end

  def manager
    Manager.find_by(employee_id: self.id)
  end

  def self.entities(employee_id)
    labor_records  = LaborRecord.where(employee_id: employee_id)
    manager        = Manager.where(employee_id: employee_id)
    manager_count  = (manager.nil? ) ? 0 : 1
    {
      labor_records: labor_records,
      manager_count: manager_count
    }
  end


  def self.removal_confirmation(employee_id)
    entities = entities(employee_id)
    confirmation = "Performing this removal will also delete: \n"

    confirmation << "* #{entities[:labor_records].count} Labor Records \n"
    confirmation << "* #{entities[:manager_count]} Manager records \n"

    confirmation << "Are you sure?"
  end

  def employee_name
    "#{first_name} #{last_name}"
  end

  def self.labor_record_dates(employee_id)
    dates_hash = Hash.new(true)
    LaborRecord.select("labor_date").where("employee_id = ?", employee_id).each do |date_object|
      dates_hash["#{date_object.labor_date}"] = true
    end
    dates_hash
  end

  # Labor Records should only be able to choose Employees that are not fired
  def self.valid
    Employee.except(eoc: true)
  end

  # ======= SEARCH ========================================

    def self.keyword_search_attributes
      attrs = [ "employees.first_name || ' ' || employees.last_name" ]
      attrs += %w{ employees.occupation employees.company_number sections.name }
    end

    def self.subclassed_order_term
      "employees.first_name asc"
    end

    def self.subclassed_join_list
      :section
    end

    def self.subclassed_includes_list
      :section
    end


end
