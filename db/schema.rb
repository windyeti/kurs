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

ActiveRecord::Schema.define(version: 2021_10_14_010900) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.string "subdomain"
    t.string "password"
    t.string "insalesid"
    t.bigint "user_id"
    t.string "inskey"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_integrations_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "payplan_id"
    t.decimal "sum"
    t.string "status", default: "Не оплачен"
    t.string "payertype"
    t.string "paymenttype"
    t.string "invoiceable_type"
    t.bigint "invoiceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["invoiceable_type", "invoiceable_id"], name: "index_invoices_on_invoiceable_type_and_invoiceable_id"
    t.index ["payplan_id"], name: "index_invoices_on_payplan_id"
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "invoice_id"
    t.bigint "payplan_id"
    t.string "status", default: "Не оплачен"
    t.string "paymenttype"
    t.string "paymentdate"
    t.string "paymentid"
    t.string "subdomain"
    t.string "paymentable_type"
    t.bigint "paymentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
    t.index ["paymentable_type", "paymentable_id"], name: "index_payments_on_paymentable_type_and_paymentable_id"
    t.index ["payplan_id"], name: "index_payments_on_payplan_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "payplans", force: :cascade do |t|
    t.string "period"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "for"
  end

  create_table "review_integrations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "integration_id"
    t.string "subdomain"
    t.string "insalesid"
    t.boolean "status", default: false
    t.boolean "ready", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["integration_id"], name: "index_review_integrations_on_integration_id"
    t.index ["user_id"], name: "index_review_integrations_on_user_id"
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
    t.string "name"
    t.string "subdomain"
    t.string "role", default: "User"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "integrations", "users"
  add_foreign_key "invoices", "payplans"
  add_foreign_key "invoices", "users"
  add_foreign_key "payments", "invoices"
  add_foreign_key "payments", "payplans"
  add_foreign_key "payments", "users"
  add_foreign_key "review_integrations", "integrations"
  add_foreign_key "review_integrations", "users"
end
