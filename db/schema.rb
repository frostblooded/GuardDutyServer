# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160503173224) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer  "company_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "calls", force: :cascade do |t|
    t.string   "token"
    t.datetime "received_at"
    t.integer  "time_left"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "worker_id"
  end

  add_index "calls", ["worker_id"], name: "index_calls_on_worker_id"

  create_table "companies", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "company_name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "companies", ["company_name"], name: "index_companies_on_company_name", unique: true
  add_index "companies", ["confirmation_token"], name: "index_companies_on_confirmation_token", unique: true
  add_index "companies", ["reset_password_token"], name: "index_companies_on_reset_password_token", unique: true

  create_table "devices", force: :cascade do |t|
    t.string   "gcm_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "worker_id"
  end

  add_index "devices", ["worker_id"], name: "index_devices_on_worker_id"

  create_table "settings", force: :cascade do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true

  create_table "workers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.integer  "company_id"
  end

  add_index "workers", ["company_id"], name: "index_workers_on_company_id"

end
