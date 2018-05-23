class Manager < ApplicationRecord
  belongs_to :employee
  belongs_to :section


  def manager_name
    "#{employee.first_name} #{employee.last_name}"
  end
  # Search by employee.first_name, employee.last_name, or section.name
  def fuzzy_search(params)

  end
end
