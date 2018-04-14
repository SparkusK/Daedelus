class Employee < ApplicationRecord
  belongs_to :section
  has_many :labor_records
  belongs_to :supervisor, polymorphic: true

  def supervisor_name
    "#{first_name} #{last_name}"
  end

  def employee_name
    "#{first_name} #{last_name}"
  end
end
