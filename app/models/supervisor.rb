class Supervisor < ApplicationRecord
  belongs_to :employee
  belongs_to :section
  has_many :labor_records

  def supervisor_name
    "#{employee.first_name} #{employee.last_name}"
  end


  validates :employee_id, presence: true
    # , message: "A Section has to be supervised by an Employee."
  validates :section_id, presence: true
    # , message: "A Supervisor has to supervise a Section."

end
