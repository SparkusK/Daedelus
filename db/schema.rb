# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180928163946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credit_notes", force: :cascade do |t|
    t.bigint "creditor_order_id"
    t.string "payment_type"
    t.decimal "amount_paid", precision: 15, scale: 2, default: "0.0"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invoice_code"
    t.index ["creditor_order_id"], name: "index_credit_notes_on_creditor_order_id"
  end

  create_table "creditor_orders", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "job_id"
    t.string "delivery_note"
    t.datetime "date_issued"
    t.decimal "value_excluding_tax", precision: 15, scale: 2, default: "0.0"
    t.decimal "tax_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "value_including_tax", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_number"
    t.index ["job_id"], name: "index_creditor_orders_on_job_id"
    t.index ["supplier_id"], name: "index_creditor_orders_on_supplier_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "debtor_orders", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "job_id"
    t.string "order_number"
    t.decimal "value_including_tax", precision: 15, scale: 2, default: "0.0"
    t.decimal "tax_amount", precision: 15, scale: 2, default: "0.0"
    t.decimal "value_excluding_tax", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_debtor_orders_on_customer_id"
    t.index ["job_id"], name: "index_debtor_orders_on_job_id"
  end

  create_table "debtor_payments", force: :cascade do |t|
    t.bigint "debtor_order_id"
    t.decimal "payment_amount", precision: 15, scale: 2, default: "0.0"
    t.string "payment_type"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "payment_date"
    t.string "invoice_code"
    t.index ["debtor_order_id"], name: "index_debtor_payments_on_debtor_order_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "occupation"
    t.bigint "section_id"
    t.string "company_number"
    t.decimal "net_rate", precision: 15, scale: 2, default: "0.0"
    t.decimal "inclusive_rate", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "eoc"
    t.index ["section_id"], name: "index_employees_on_section_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.date "receive_date"
    t.bigint "section_id"
    t.string "contact_person"
    t.string "responsible_person"
    t.decimal "total", precision: 15, scale: 2, default: "0.0", null: false
    t.string "work_description"
    t.string "jce_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "quotation_reference"
    t.decimal "targeted_amount", precision: 15, scale: 2, default: "0.0", null: false
    t.index ["section_id"], name: "index_jobs_on_section_id"
  end

  create_table "labor_records", force: :cascade do |t|
    t.bigint "employee_id"
    t.date "labor_date", null: false
    t.decimal "hours", precision: 6, scale: 4, default: "0.0"
    t.decimal "total_before", precision: 15, scale: 2, default: "0.0"
    t.decimal "total_after", precision: 15, scale: 2, default: "0.0"
    t.bigint "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "section_id"
    t.index ["employee_id"], name: "index_labor_records_on_employee_id"
    t.index ["job_id"], name: "index_labor_records_on_job_id"
    t.index ["section_id"], name: "index_labor_records_on_section_id"
  end

  create_table "managers", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_managers_on_employee_id"
    t.index ["section_id"], name: "index_managers_on_section_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "overheads", precision: 12, scale: 2, default: "0.0"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "credit_notes", "creditor_orders"
  add_foreign_key "creditor_orders", "jobs"
  add_foreign_key "creditor_orders", "suppliers"
  add_foreign_key "debtor_orders", "customers"
  add_foreign_key "debtor_orders", "jobs"
  add_foreign_key "debtor_payments", "debtor_orders"
  add_foreign_key "employees", "sections"
  add_foreign_key "jobs", "sections"
  add_foreign_key "labor_records", "employees"
  add_foreign_key "labor_records", "jobs"
  add_foreign_key "labor_records", "sections"
  add_foreign_key "managers", "employees"
  add_foreign_key "managers", "sections"
end
