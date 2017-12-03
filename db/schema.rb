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

ActiveRecord::Schema.define(version: 20171202050721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calculation_names", force: :cascade do |t|
    t.string "calculation_name", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calculation_name"], name: "index_calculation_names_on_calculation_name", unique: true
    t.index ["user_id"], name: "index_calculation_names_on_user_id"
  end

  create_table "current_weekly_rates", force: :cascade do |t|
    t.string "base", null: false
    t.date "week", null: false
    t.decimal "AUD", precision: 8, scale: 3
    t.decimal "BGN", precision: 8, scale: 3
    t.decimal "BRL", precision: 8, scale: 3
    t.decimal "CAD", precision: 8, scale: 3
    t.decimal "CHF", precision: 8, scale: 3
    t.decimal "CNY", precision: 8, scale: 3
    t.decimal "CZK", precision: 8, scale: 3
    t.decimal "DKK", precision: 8, scale: 3
    t.decimal "EUR", precision: 8, scale: 3
    t.decimal "GBP", precision: 8, scale: 3
    t.decimal "HKD", precision: 8, scale: 3
    t.decimal "HRK", precision: 8, scale: 3
    t.decimal "HUF", precision: 8, scale: 3
    t.decimal "IDR", precision: 8, scale: 3
    t.decimal "ILS", precision: 8, scale: 3
    t.decimal "INR", precision: 8, scale: 3
    t.decimal "JPY", precision: 8, scale: 3
    t.decimal "KRW", precision: 8, scale: 3
    t.decimal "MXN", precision: 8, scale: 3
    t.decimal "MYR", precision: 8, scale: 3
    t.decimal "NOK", precision: 8, scale: 3
    t.decimal "NZD", precision: 8, scale: 3
    t.decimal "PHP", precision: 8, scale: 3
    t.decimal "PLN", precision: 8, scale: 3
    t.decimal "RON", precision: 8, scale: 3
    t.decimal "RUB", precision: 8, scale: 3
    t.decimal "SEK", precision: 8, scale: 3
    t.decimal "SGD", precision: 8, scale: 3
    t.decimal "THB", precision: 8, scale: 3
    t.decimal "TRY", precision: 8, scale: 3
    t.decimal "USD", precision: 8, scale: 3
    t.decimal "ZAR", precision: 8, scale: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "historical_weekly_rates", force: :cascade do |t|
    t.string "base", null: false
    t.date "week", null: false
    t.decimal "AUD", precision: 8, scale: 3
    t.decimal "BGN", precision: 8, scale: 3
    t.decimal "BRL", precision: 8, scale: 3
    t.decimal "CAD", precision: 8, scale: 3
    t.decimal "CHF", precision: 8, scale: 3
    t.decimal "CNY", precision: 8, scale: 3
    t.decimal "CZK", precision: 8, scale: 3
    t.decimal "DKK", precision: 8, scale: 3
    t.decimal "EUR", precision: 8, scale: 3
    t.decimal "GBP", precision: 8, scale: 3
    t.decimal "HKD", precision: 8, scale: 3
    t.decimal "HRK", precision: 8, scale: 3
    t.decimal "HUF", precision: 8, scale: 3
    t.decimal "IDR", precision: 8, scale: 3
    t.decimal "ILS", precision: 8, scale: 3
    t.decimal "INR", precision: 8, scale: 3
    t.decimal "JPY", precision: 8, scale: 3
    t.decimal "KRW", precision: 8, scale: 3
    t.decimal "MXN", precision: 8, scale: 3
    t.decimal "MYR", precision: 8, scale: 3
    t.decimal "NOK", precision: 8, scale: 3
    t.decimal "NZD", precision: 8, scale: 3
    t.decimal "PHP", precision: 8, scale: 3
    t.decimal "PLN", precision: 8, scale: 3
    t.decimal "RON", precision: 8, scale: 3
    t.decimal "RUB", precision: 8, scale: 3
    t.decimal "SEK", precision: 8, scale: 3
    t.decimal "SGD", precision: 8, scale: 3
    t.decimal "THB", precision: 8, scale: 3
    t.decimal "TRY", precision: 8, scale: 3
    t.decimal "USD", precision: 8, scale: 3
    t.decimal "ZAR", precision: 8, scale: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_weekly_calculations", force: :cascade do |t|
    t.date "year_and_week", null: false
    t.float "predicted_rate", null: false
    t.float "sum", null: false
    t.float "profit_loss", null: false
    t.float "rank"
    t.bigint "user_id"
    t.bigint "calculation_name_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calculation_name_id"], name: "index_saved_weekly_calculations_on_calculation_name_id"
    t.index ["user_id"], name: "index_saved_weekly_calculations_on_user_id"
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

  add_foreign_key "calculation_names", "users"
  add_foreign_key "saved_weekly_calculations", "calculation_names"
  add_foreign_key "saved_weekly_calculations", "users"
end
