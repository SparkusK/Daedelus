class Employee < ApplicationRecord
  belongs_to :section
  has_many :labor_records
  has_one :supervisor
  has_one :manager

  def employee_name
    "#{first_name} #{last_name}"
  end

  # Search by first_name, last_name, occupation, section, or company number
  def fuzzy_search(params)

  end


end
