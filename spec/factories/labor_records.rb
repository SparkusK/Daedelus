FactoryBot.define do
  factory :labor_record do
    employee_id = FactoryBot.create(:employee).id
    employee_id { employee_id }
    labor_date = Date.today
    labor_date { labor_date }
    hours = 8.5
    hours { hours }
    job_id { FactoryBot.create(:job).id }
    section_id { FactoryBot.create(:section).id }
    amounts = LaborRecord.calculate_amounts(Employee.find_by(id: employee_id), labor_date, hours)
    normal_time_amount_before_tax { amounts[:normal_time_amount_before_tax] }
    normal_time_amount_after_tax { amounts[:normal_time_amount_after_tax] }
    overtime_amount_before_tax { amounts[:overtime_amount_before_tax] }
    overtime_amount_after_tax { amounts[:overtime_amount_after_tax] }
    sunday_time_amount_before_tax { amounts[:sunday_time_amount_before_tax] }
    sunday_time_amount_after_tax { amounts[:sunday_time_amount_after_tax] }
  end
end
