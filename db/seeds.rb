
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


def rng_percentage_check(perc)
  Faker::Number.decimal(0,2).to_f < perc
end

def create_labor_record(emp, date, total_perc, supervisor_id, job_id)
  hours = Random.rand(24.0).truncate(4)
  total_before = emp.inclusive_rate * hours
  total_after = total_before * total_perc
  LaborRecord.create(
    employee_id: emp.id,
    day_of_the_week: date.strftime('%A'),
    labor_date: date,
    hours: hours,
    total_before: total_before,
    total_after: total_after,
    supervisor_id: supervisor_id,
    job_id: job_id
  )
end

def gen_records_for_employee(loop_date, emp)
  today = Date.today
  new_loop_date = loop_date.clone
  while ((today - new_loop_date.to_date).to_i > 5)
    do_stuff(new_loop_date, emp)
    new_loop_date += 1.day
  end
  puts "    Ending date: #{new_loop_date}"
end

def do_stuff(loop_date, emp)
  if (loop_date.wday == 0 && rng_percentage_check(0.85))
    # puts "Skipping because Sunday rng"
  elsif (loop_date.wday == 6 && rng_percentage_check(0.65))
    # puts "Skipping because Saturday rng"
  else
    random_job = Job.where("receive_date < ?", loop_date).sample
    if (random_job.nil?)
      # puts "Skipping because no Jobs"
    else
      # puts "Creating labor record"
      create_labor_record(emp, loop_date, 1.2, get_supervisor_id(emp), random_job.id) # create a labor record
    end
  end
end

@employees = Employee.all.to_a.shuffle

start_time = Time.now
employee_count = @employees.count
idx = 0

@employees.each { |emp|
  start_time_emp = Time.now
  starting_date = Faker::Time.backward(90)
  puts "Employee #{idx+1}:"
  puts "  Starting date: #{starting_date}"
  loop_date = starting_date
  supervisor_id = get_supervisor_id(emp)
  puts "  Supervisor id: #{supervisor_id}"
  gen_records_for_employee(loop_date, emp)
  end_time_emp = Time.now
  idx += 1
  puts "Employee #{idx}/#{employee_count} done. Time taken: #{((end_time_emp - start_time_emp)).truncate(3)} seconds"
}
puts "Labor Records done."
put_count(LaborRecord, "labor record")
puts "================================"

def create_records(amount, entity)
  puts "==============================="
  puts "Creating #{amount} #{entity.pluralize}..."
  yield
  puts "Done."
  puts "==============================="
end

def create_customers(amount)
  create_records(amount, "Customer") do
    amount.times {
      Customer.create(
        name: "#{Faker::Company.unique.name}#{Faker::Company.suffix}",
        email: "#{Faker::Internet.unique.email}",
        phone: "0#{Faker::Number.unique.number(9)}"
      )
    }
  end
end

def create_suppliers(amount)
  create_records(amount, "Supplier") do

  end
end

def create_sections(amount)
  create_records(amount, "Section") do
    # Get #{amount} random, unique Departments from Faker
    departments = Faker::Commerce.department(amount, true)

    # Sanitize the result a bit
    sections = departments.gsub(" & ", ", ").split(", ")

    # Iterate the results, create #{amount} Sections
    sections.each { |sec|
      Section.create(
        name: "#{sec}",
        overheads: Faker::Number.within(10000..500000)
      )
    }
  end
end

def create_jobs(amount)
  create_records(amount, "Job") do

    @debtor_orders_base = DebtorOrder.all.to_a.shuffle
    @quotations = Quotation.all.to_a.shuffle

    @debtor_orders_jobs = DebtorOrder.all.to_a.shuffle

    Invoice.count.times {
      debtor_order = @debtor_orders_jobs.pop
        Job.create(
          receive_date: Faker::Time.backward(730),
          section_id: Section.all.sample.id,
          contact_person: Faker::Name.first_name,
          balow_section: Faker::Lorem.characters(6),
          total: debtor_order.value_including_tax,
          work_description: Faker::Lorem.sentence,
          jce_number: Faker::Lorem.characters(8).upcase,
          debtor_order_id: debtor_order.id,
          quotation_id: @quotations.pop.id
        )
    }

  end
end

def create_debtor_orders(amount)
  create_records(amount, "Debtor Order") do

    @invoices = Invoice.all.to_a.shuffle
    Invoice.count.times {

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
    }

  end
end

def create_debtor_payments(amount)
  create_records(amount, "Debtor Payment") do

  end
end

def create_creditor_orders(amount)
  create_records(amount, "Creditor Order") do

  end
end

def create_creditor_payments(amount)
  create_records(amount, "Creditor Payment") do

  end
end

def create_employees(amount)
  create_records(amount, "Employee") do

    @section_count = Section.count

    amount.times {
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
    }

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

def create_managers(amount)
  create_records(amount, "Manager") do
    amount.times {
      Manager.create(
        employee_id: EmployeesController.helpers.leaf_employees().sample.id,
        section_id: SectionsController.helpers.unmanaged_sections().sample.id
      )
    }
  end
end

def create_labor_records(amount)
  create_records(amount, "Labor Record") do

  end
end




# 11.	Debtor Payments
# Couple of different things to note:
# We want some Orders to be fulfilled on time with 1 payment.
# We want some Orders to be fulfilled late, with 1 payment.
# We want some Orders to not be fulfilled.
# We want some Orders to be fulfilled on time, but with more than 1 payment.
# We want some Orders to be fulfilled late, but with more than 1 payment.
#
# ... well, we don't really know what "on time" means in the context of our
# database structure. We don't have a "payment due date" column anywhere. Do we?
# I checked, and no, we don't. I'm just gonna skip it for now.
#
# The new stuffs to sim:
# We want some Orders to be fulfilled with 1 payment.
# We want some Orders to be fulfilled with more than 1 payment.
# We want some Orders to not be fulfilled with 0 payments.
# We want some Orders to be partially fulfilled with more than 0 payments.

puts "Creating Debtor Payments..."


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

@debtor_orders_base.each { |order|
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
        create_debtor_payment(order.id, amt_fulfilled / amt_payments, order.created_at + i.day)
      }
  end
}
puts "DebtorPayments done."
put_count(DebtorPayment, "debtor payment")
puts "================================"

# 12.	Suppliers
# 40 Suppliers?

puts "Creating Suppliers..."


40.times {
  Supplier.create(
    name: "#{Faker::Company.unique.name}#{Faker::Company.suffix}",
    email: Faker::Internet.email,
    phone: "0#{Faker::Number.unique.number(9)}"
  )
}
puts "Suppliers done."
put_count(Supplier, "supplier")
puts "================================"

# 13.	Creditor Orders
# 250 creditor orders.

puts "Creating Creditor Orders..."

250.times {
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
    reference_number: "#{('A'..'Z').to_a.sample}#{Faker::Number.unique.number(4)}"
  )
}
puts "Creditor Orders done."
put_count(CreditorOrder, "creditor order")
puts "================================"

# 14.	Credit Notes
# We want some Orders to be fulfilled on time with 1 payment.
# We want some Orders to be fulfilled late, with 1 payment.
# We want some Orders to not be fulfilled.
# We want some Orders to be fulfilled on time, but with more than 1 payment.
# We want some Orders to be fulfilled late, but with more than 1 payment.

puts "Creating Credit Notes..."

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


puts "CreditNotes done."
put_count(CreditNote, "credit note")
puts "================================"
