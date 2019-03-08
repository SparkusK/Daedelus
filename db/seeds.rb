# -- Main logic ---------------------------------------------------------------

def seeds
  create_customers(50)
  create_suppliers(50)
  create_sections(5)
  create_jobs(50)
  create_debtor_orders(300)
  create_debtor_payments(400)
  create_creditor_orders(250)
  create_creditor_payments(400)
  create_employees(20)
  create_managers(4)
  create_labor_records(200)
end

# ==== Helpers =================================================================
# ==============================================================================

def create_labor_record(emp, date, hours, job, section, amounts)
  LaborRecord.create(
    employee_id: emp.id,
    labor_date: date,
    hours: hours,
    job_id: job.id,
    section_id: section.id,
    normal_time_amount_before_tax: amounts[normal_time_amount_before_tax],
    normal_time_amount_after_tax: amounts[normal_time_amount_after_tax],
    overtime_amount_before_tax: amounts[overtime_amount_before_tax],
    overtime_amount_after_tax: amounts[overtime_amount_after_tax],
    sunday_time_amount_before_tax: amounts[sunday_time_amount_before_tax],
    sunday_time_amount_after_tax: amounts[sunday_time_amount_after_tax]
  )
end

def create_debtor_payment(order_id, amount, date)
  DebtorPayment.create(
    debtor_order_id: order_id,
    payment_amount: amount,
    payment_date: date,
    payment_type: "cash",
    note: Faker::Lorem.sentence
  )

  order = DebtorOrder.find(order_id)
  order_owed_amount = order.still_owed_amount
  order.update(still_owed_amount: order_owed_amount - amount)
end


def create_credit_note(order_id, amount)
  CreditNote.create(
    creditor_order_id: order_id,
    amount_paid: amount,
    payment_type: "cash",
    note: Faker::Lorem.sentence
  )
  order = CreditorOrder.find(order_id)
  order_owed_amount = order.still_owed_amount
  order.update(still_owed_amount: order_owed_amount - amount)
end

def generate_reference_number
  "#{('A'..'Z').to_a.sample}#{Faker::Number.unique.number(4)}"
end

def check_and_roll_weekends(date)
  !( date.wday == 0 && rng_percentage_check(0.7)
  || date.wday == 6 && rng_percentage_check(0.4) )
end


def do_stuff(loop_date, emp)
  if check_and_roll_weekends(loop_date)
    random_job = Job.where("receive_date < ?", loop_date).sample
    if (!random_job.nil?)
      hours = rand(1..23)
      amounts = LaborRecord.calculate_amounts(employee, date)
      create_labor_record(emp, loop_date,)
    end
  end
end

@employees = Employee.all.to_a.shuffle
@employees.each { |emp|
  starting_date = Faker::Time.backward(60)
  today = Date.today
  while ((today - starting_date.to_date).to_i > 5)
    do_stuff(starting_date, emp)
    starting_date += 1.day
  end
}

def rng_percentage_check(perc)
  Faker::Number.decimal(0,2).to_f < perc
end

def with_console_output(amount, entity)
  puts "==============================="
  puts "Creating #{amount} #{entity.pluralize}..."
  yield
  puts "Done."
  puts "==============================="
end

# ==== Record creation functions ===============================================
# ==============================================================================


# -- 1. Customers --------------------------------------------------------------
def create_customers(amount)
  with_console_output(amount, "Customer") do
    amount.times do
      Customer.create(
        name: "#{Faker::Company.unique.name}#{Faker::Company.suffix}",
        email: "#{Faker::Internet.unique.email}",
        phone: "0#{Faker::Number.unique.number(9)}"
      )
    end
  end
end

# -- 2. Suppliers --------------------------------------------------------------
def create_suppliers(amount)
  with_console_output(amount, "Supplier") do
    amount.times do
      Supplier.create(
        name: "#{Faker::Company.unique.name}#{Faker::Company.suffix}",
        email: Faker::Internet.email,
        phone: "0#{Faker::Number.unique.number(9)}"
      )
    end
  end
end

# -- 3. Sections ---------------------------------------------------------------
def create_sections(amount)
  with_console_output(amount, "Section") do
    departments = Faker::Commerce.department(amount, true)
    section_names = departments.gsub(" & ", ", ").split(", ")
    section_names.each do |name|
      Section.create(
        name: "#{name}",
        overheads: Faker::Number.within(10000..500000)
      )
    end
  end
end

# -- 4. Jobs -------------------------------------------------------------------
def create_jobs(amount)
  with_console_output(amount, "Job") do
    amount.times do
      total = rand(50000)
      targeted_amount = rand(total)
      is_finished = (targeted_amount == total)
      receive_date = Faker::Date.backward(60)
      receive_date_days_ago = (Date.today - receive_date).to_i.abs
      target_date = Faker::Date.backward(receive_date_days_ago)
      Job.create(
        receive_date: receive_date,
        section_id: Section.all.sample.id,
        contact_person: Faker::Name.first_name,
        responsible_person: Faker::Name.last_name,
        total: total,
        work_description: Faker::Lorem.sentence,
        jce_number: Faker::Lorem.characters(8).upcase,
        quotation_reference: Faker::Lorem.characters(6),
        targeted_amount: targeted_amount,
        target_date: target_date,
        is_finished: is_finished
      )
    end
  end
end

# -- 5. Debtor Orders ----------------------------------------------------------
def create_debtor_orders(amount)
  with_console_output(amount, "Debtor Order") do
    amount.times do
      order_value_excluding = Faker::Number.decimal(5, 2).to_f
      order_tax_amount = order_value_excluding*0.15
      order_value_including = order_value_excluding + order_tax_amount
      DebtorOrder.create(
        customer_id: Customer.all.sample.id,
        job_id: nil,
        invoice_id: @invoices.pop.id,
        SA_number: Faker::Lorem.characters(6),
        value_including_tax: order_value_including,
        value_excluding_tax: order_value_excluding,
        tax_amount: order_tax_amount,
        still_owed_amount: order_value_including
      )
    end
  end
end

# -- 6. Debtor Payments --------------------------------------------------------
def create_debtor_payments(amount)
  with_console_output(amount, "Debtor Payment") do
    debtor_orders = DebtorOrder.all.to_a.shuffle
    debtor_orders.each { |order|
      amt_payments = Random.rand(4)
      if (amt_payments == 0) then next
      else
        if rng_percentage_check(0.2) # Partially fulfilled
          perc_fulfilled = Faker::Number.decimal(0,2).to_f
        else
          perc_fulfilled = 1.0
        end
          amt_fulfilled = order.still_owed_amount * perc_fulfilled
          amt_payments.times { |i|
            create_debtor_payment(order.id,
              amt_fulfilled / amt_payments,
              order.created_at + i.day)
          }
      end
    }
  end
end

# -- 7. Creditor Orders --------------------------------------------------------
def create_creditor_orders(amount)
  with_console_output(amount, "Creditor Order") do
    amount.times do
      amt_excl = Faker::Number.decimal(5,2).to_f
      CreditorOrder.create(
        supplier_id: Supplier.all.sample.id,
        job_id: Job.all.sample.id,
        invoice_id: Invoice.all.sample.id,
        delivery_note: Faker::Lorem.sentence,
        date_issued: Faker::Time.backward(700),
        value_excluding_tax: amt_excl,
        value_including_tax: amt_excl*1.15,
        still_owed_amount: amt_excl*1.15,
        reference_number: generate_reference_number()
      )
    end
  end
end

# -- 8. Creditor Payments ------------------------------------------------------
def create_creditor_payments(amount)
  with_console_output(amount, "Creditor Payment") do
    CreditorOrder.all.to_a.shuffle.each { |order|
      amt_payments = Random.rand(4)
      if (amt_payments == 0) then next
      else
        if rng_percentage_check(0.2) # Partially fulfilled
          perc_fulfilled = Faker::Number.decimal(0,2).to_f
        else
          perc_fulfilled = 1.0
        end
          amt_fulfilled = order.still_owed_amount * perc_fulfilled
          amt_payments.times { |i|
            create_credit_note(order.id, amt_fulfilled / amt_payments)
          }
      end
    }
  end
end

# -- 9. Employees --------------------------------------------------------------
def create_employees(amount)
  with_console_output(amount, "Employee") do
    @section_count = Section.count
    amount.times do
      @net_rate = Faker::Number.decimal(2,2).to_f
      Employee.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        occupation: Faker::Name.unique.title,
        section_id: Section.offset(rand(@section_count)).first.id,
        company_number: Faker::Code.unique.asin,
        net_rate: @net_rate,
        inclusive_rate: @net_rate*1.06
      )
    end
    2.times {
      @net_rate = Faker::Number.decimal(2,2).to_f
      Employee.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        occupation: Faker::Name.unique.title,
        section_id: Section.offset(rand(@section_count)).first.id,
        company_number: Faker::Code.unique.asin,
        net_rate: @net_rate,
        inclusive_rate: @net_rate*1.06,
        eoc: true
      )
    }
  end
end

# -- 10. Managers --------------------------------------------------------------
def create_managers(amount)
  with_console_output(amount, "Manager") do
    amount.times do
      Manager.create(
        employee_id: EmployeesController.helpers.leaf_employees().sample.id,
        section_id: SectionsController.helpers.unmanaged_sections().sample.id
      )
    end
  end
end

# -- 11. Labor Records ---------------------------------------------------------
def create_labor_records(amount)
  with_console_output(amount, "Labor Record") do

  end
end
