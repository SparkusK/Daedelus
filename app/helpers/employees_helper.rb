module EmployeesHelper
  def get_supervisors
    Employee.where(:is_supervisor=>true)
  end
end
