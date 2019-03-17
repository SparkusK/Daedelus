# -- Main logic ---------------------------------------------------------------

def seeds
  create_customers(50)
  create_suppliers(50)
  create_sections(5)
  create_jobs(50)
  create_job_targets(200)
  create_debtor_orders(300)
  create_debtor_payments(400)
  create_creditor_orders(250)
  create_creditor_payments(400)
  create_employees(20)
  create_managers(4)
  create_labor_records(150)
end

# ==== Helpers =================================================================
# ==============================================================================

def create_labor_record(emp, date, hours, job, section, amounts)
  amounts = LaborRecord.calculate_amounts(emp, date, hours)
  LaborRecord.create(
    employee_id: emp.id,
    labor_date: date,
    hours: hours,
    job_id: job.id,
    section_id: section.id,
    normal_time_amount_before_tax: amounts[:normal_time_amount_before_tax],
    normal_time_amount_after_tax: amounts[:normal_time_amount_after_tax],
    overtime_amount_before_tax: amounts[:overtime_amount_before_tax],
    overtime_amount_after_tax: amounts[:overtime_amount_after_tax],
    sunday_time_amount_before_tax: amounts[:sunday_time_amount_before_tax],
    sunday_time_amount_after_tax: amounts[:sunday_time_amount_after_tax]
  )
end

def check_and_roll_weekends(date)
  !( (date.wday == 0 && rng_percentage_check(0.7)) || (date.wday == 6 && rng_percentage_check(0.4)) )
end

def check_and_create_record(loop_date, emp)
  if check_and_roll_weekends(loop_date)
    random_job = Job.where("receive_date < ?", loop_date).sample
    if (!random_job.nil?)
      hours = rand(1..23)
      amounts = LaborRecord.calculate_amounts(emp, loop_date, hours)
      sec = random_job.section
      create_labor_record(emp, loop_date, hours, random_job, sec, amounts)
    end
  end
end

def target_a_job(job)
  total_targets = JobTarget.where(job_id: job.id).sum(:target_amount)
  amount_remaining = job.total*1.2 - total_targets
  target_amount = rand(amount_remaining.abs)
  total_targets += target_amount
  if total_targets > job.total*1.2
    job.update_attributes(is_finished: true)
  elsif total_targets > job.total && rng_percentage_check(0.7)
    job.update_attributes(is_finished: true)
  elsif total_targets > job.total*0.8 && rng_percentage_check(0.25)
    job.update_attributes(is_finished: true)
  end
  target_amount
end

def generate_reference_number
  "#{('A'..'Z').to_a.sample}#{Faker::Number.unique.number(4)}"
end

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
        overheads: Faker::Number.between(10000, 500000)
      )
    end
  end
end

# -- 4. Jobs -------------------------------------------------------------------
def create_jobs(amount)
  with_console_output(amount, "Job") do
    amount.times do
      total = rand(50000)
      is_finished = false
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
        is_finished: is_finished,
        job_number: Faker::Lorem.characters(10).upcase,
        order_number: Faker::Lorem.characters(12).upcase,
        client_section: Faker::Lorem.word
      )
    end
  end
end

# -- 5. Job Targets ------------------------------------------------------------
def create_job_targets(amount)
  with_console_output(amount, "Job Targets") do
    amount.times do
      job = Job.where(is_finished: false).sample
      if job != nil
        job_days_ago = (Date.today - job.receive_date).to_i.abs
        job_target_date = Faker::Date.backward(job_days_ago)
        invoice_number = Faker::Lorem.characters(7).upcase
        remarks = Faker::Lorem.sentence if rng_percentage_check(0.3)
        details = Faker::Lorem.sentence if rng_percentage_check(0.7)
        job_id = job.id
        section_id = job.section.id
        target_amount = target_a_job(job)
        JobTarget.create(
          target_date: job_target_date,
          invoice_number: invoice_number,
          remarks: remarks,
          details: details,
          target_amount: target_amount,
          section_id: section_id,
          job_id: job_id
        )
      end
    end
  end
end

# -- 6. Debtor Orders ----------------------------------------------------------
def create_debtor_orders(amount)
  with_console_output(amount, "Debtor Order") do
    amount.times do
      order_value_excluding = Faker::Number.decimal(5, 2).to_f
      order_tax_amount = order_value_excluding*0.15
      order_value_including = order_value_excluding + order_tax_amount
      DebtorOrder.create(
        customer_id: Customer.all.sample.id,
        job_id: Job.all.sample.id,
        order_number: Faker::Lorem.characters(6),
        value_including_tax: order_value_including,
        value_excluding_tax: order_value_excluding,
        tax_amount: order_tax_amount
      )
    end
  end
end

# -- 7. Debtor Payments --------------------------------------------------------
def create_debtor_payments(amount)
  with_console_output(amount, "Debtor Payment") do
    # I have to maintain a list here of debtor_order_ids, their total_payment
    # values, and their value_excluding_tax values. This is because
    # I cannot wrangle the SQL to do what I want it to do, and
    # even if I could, if I were to check everytime with a SQL query, it would
    # anyway be really slow. Let's just do it manually! Yay!

    orders = Hash.new(nil)

    DebtorOrder.select("id, value_excluding_tax").each do |db_order|
      orders[db_order.id] = {
        value_excluding_tax: db_order.value_excluding_tax,
        amount_of_payments: 0,
        total_payments: 0.0
      }
    end
    amount.times do
      id = orders.keys.sample
      random_order = orders[id]
      if rng_percentage_check(0.05 * (random_order[:amount_of_payments] + 1) )
        amnt = random_order[:value_excluding_tax] - random_order[:total_payments]
        DebtorPayment.create(
          debtor_order_id: id,
          payment_amount: amnt,
          payment_type: "cash",
          note: Faker::Lorem.sentence,
          payment_date: Faker::Date.backward(60),
          invoice_code: Faker::Lorem.word
        )
        orders.except!(id)
      else
        max = random_order[:value_excluding_tax] - random_order[:total_payments]
        amnt = rand(max)
        DebtorPayment.create(
          debtor_order_id: id,
          payment_amount: amnt,
          payment_type: "cash",
          note: Faker::Lorem.sentence,
          payment_date: Faker::Date.backward(60),
          invoice_code: Faker::Lorem.word
        )
        random_order[:amount_of_payments] += 1
        random_order[:total_payments] += amnt
      end
    end
  end
end

# -- 8. Creditor Orders --------------------------------------------------------
def create_creditor_orders(amount)
  with_console_output(amount, "Creditor Order") do
    amount.times do
      amt_excl = Faker::Number.decimal(5,2).to_f
      CreditorOrder.create(
        supplier_id: Supplier.all.sample.id,
        job_id: Job.all.sample.id,
        delivery_note: Faker::Lorem.sentence,
        date_issued: Faker::Time.backward(700),
        value_excluding_tax: amt_excl,
        tax_amount: amt_excl * 0.15,
        value_including_tax: amt_excl*1.15,
        reference_number: generate_reference_number()
      )
    end
  end
end

# -- 9. Creditor Payments ------------------------------------------------------
def create_creditor_payments(amount)
  with_console_output(amount, "Creditor Payment") do
    # I have to maintain the same type of list as in Debtor Payments creation.
    # See that one's notes why; they're the same

    orders = Hash.new(nil)

    CreditorOrder.select("id, value_excluding_tax").each do |db_order|
      orders[db_order.id] = {
        value_excluding_tax: db_order.value_excluding_tax,
        amount_of_payments: 0,
        total_payments: 0.0
      }
    end
    amount.times do
      id = orders.keys.sample
      random_order = orders[id]
      if rng_percentage_check(0.05 * (random_order[:amount_of_payments] + 1) )
        amnt = random_order[:value_excluding_tax] - random_order[:total_payments]
        CreditNote.create(
          creditor_order_id: id,
          payment_type: "cash",
          amount_paid: amnt,
          note: Faker::Lorem.sentence,
          invoice_code: Faker::Lorem.word
        )
        orders.except!(id)
      else
        max = random_order[:value_excluding_tax] - random_order[:total_payments]
        amnt = rand(max)
        CreditNote.create(
          creditor_order_id: id,
          payment_type: "cash",
          amount_paid: amnt,
          note: Faker::Lorem.sentence,
          invoice_code: Faker::Lorem.word
        )
        random_order[:amount_of_payments] += 1
        random_order[:total_payments] += amnt
      end
    end
  end
end

# -- 10. Employees -------------------------------------------------------------
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

# -- 11. Managers --------------------------------------------------------------
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

# -- 12. Labor Records ---------------------------------------------------------
def create_labor_records(days_backwards)
  puts "==============================="
  puts "Creating Labor Records for Employees backward until potentially #{days_backwards.days.ago.to_date.strftime("%B %-d, %Y")}..."
  @employees = Employee.all.to_a.shuffle
  count = @employees.count
  @employees.each_with_index { |emp, ind|
    starting_date = Faker::Date.backward(days_backwards)
    today = Date.today
    puts "\t Starting with employee #{ind} on  #{starting_date.strftime("%B %-d, %Y")} ..."
    while ((today - starting_date.to_date).to_i > 5)
      check_and_create_record(starting_date, emp)
      starting_date += 1.day
    end
    puts "\t employee #{ind} done."
    puts "------------------------"
  }
  puts "Done."
  puts "==============================="
end

seeds()
