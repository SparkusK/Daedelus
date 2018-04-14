module EmployeesHelper

  def promotable_employees
    Employee.all.select { |emp| emp if emp.supervisor.nil? }
  end

end
