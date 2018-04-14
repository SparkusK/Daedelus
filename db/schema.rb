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

ActiveRecord::Schema.define(version: 20180414120127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.boolean "is_supervisor"
    t.string "occupation"
    t.bigint "section_id"
    t.string "company_number"
    t.decimal "net_rate"
    t.decimal "inclusive_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_employees_on_section_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "receive_date"
    t.bigint "section_id"
    t.string "contact_person"
    t.string "balow_section"
    t.decimal "total"
    t.string "work_description"
    t.string "jce_number"
    t.bigint "order_id"
    t.bigint "quotation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_jobs_on_order_id"
    t.index ["quotation_id"], name: "index_jobs_on_quotation_id"
    t.index ["section_id"], name: "index_jobs_on_section_id"
  end

  create_table "labor_records", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "day_of_the_week"
    t.date "labor_date"
    t.decimal "hours"
    t.decimal "total_before"
    t.decimal "total_after"
    t.bigint "supervisor_id"
    t.bigint "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_labor_records_on_employee_id"
    t.index ["job_id"], name: "index_labor_records_on_job_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "employees", "sections"
  add_foreign_key "jobs", "orders"
  add_foreign_key "jobs", "quotations"
  add_foreign_key "jobs", "sections"
  add_foreign_key "labor_records", "employees"
  add_foreign_key "labor_records", "employees", column: "supervisor_id"
  add_foreign_key "labor_records", "jobs"
end
