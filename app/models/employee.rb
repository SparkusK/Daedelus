class Employee < ApplicationRecord
  belongs_to :section
  has_many :labor_records
  has_one :supervisor

  def employee_name
    "#{first_name} #{last_name}"
  end


end
