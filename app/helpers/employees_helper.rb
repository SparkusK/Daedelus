module EmployeesHelper

  def non_supervisor_employees
    Employee.all.select { |emp| emp if emp.supervisor.nil? }
  end

  def non_manager_employees
    Employee.all.select { |emp| emp if emp.manager.nil?}
  end

  def leaf_employees
    Employee.all.select { |emp| emp if emp.supervisor.nil? && emp.manager.nil? }
  end

end
