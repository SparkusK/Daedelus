class Employee < ApplicationRecord
  belongs_to :section
  has_many :labor_records
  has_one :supervisor
  has_one :manager

  def employee_name
    "#{first_name} #{last_name}"
  end

  # Search by first_name, last_name, occupation, section, or company number
  def self.search(keywords)
    search_term = keywords.downcase + '%'
    Employee.where("lower(first_name) LIKE ? OR lower(last_name) LIKE ?", search_term, search_term)
      .order("last_name asc")
  end


end
