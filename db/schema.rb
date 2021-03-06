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

ActiveRecord::Schema.define(version: 20170601114650) do

  create_table "activities", force: :cascade do |t|
    t.integer  "category"
    t.integer  "time_left"
    t.integer  "worker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "site_id"
    t.index ["site_id"], name: "index_activities_on_site_id"
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.integer  "company_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["access_token"], name: "index_api_keys_on_access_token", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "last_mail_sent_at"
    t.text     "settings"
    t.string   "email_time"
    t.boolean  "email_wanted"
    t.string   "report_locale",          default: "en"
    t.index ["confirmation_token"], name: "index_companies_on_confirmation_token", unique: true
    t.index ["name"], name: "index_companies_on_name", unique: true
    t.index ["reset_password_token"], name: "index_companies_on_reset_password_token", unique: true
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "company_id"
    t.integer  "call_interval"
    t.string   "shift_start"
    t.string   "shift_end"
    t.index ["company_id"], name: "index_sites_on_company_id"
  end

  create_table "sites_workers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "site_id"
    t.integer  "worker_id"
  end

  create_table "workers", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "name"
    t.integer  "company_id"
    t.float    "trust_score",     default: 100.0
    t.index ["company_id"], name: "index_workers_on_company_id"
  end

end
