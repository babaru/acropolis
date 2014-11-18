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

ActiveRecord::Schema.define(version: 20141118015737) do

  create_table "banks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brokers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "capital_accounts", force: true do |t|
    t.string   "name"
    t.decimal  "budget",     precision: 20, scale: 4
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capital_accounts", ["client_id"], name: "index_capital_accounts_on_client_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchanges", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.string   "full_cn_name"
    t.string   "short_cn_name"
    t.string   "full_en_name"
    t.string   "short_en_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_unit"
  end

  create_table "instruments", force: true do |t|
    t.string   "name"
    t.string   "symbol_id"
    t.string   "type"
    t.integer  "underlying_id"
    t.datetime "expiration_date"
    t.decimal  "strike_price",    precision: 20, scale: 4
    t.integer  "exchange_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_unit"
  end

  add_index "instruments", ["exchange_id"], name: "index_instruments_on_exchange_id", using: :btree
  add_index "instruments", ["underlying_id"], name: "index_instruments_on_underlying_id", using: :btree

  create_table "monitoring_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monitoring_products", ["product_id"], name: "index_monitoring_products_on_product_id", using: :btree
  add_index "monitoring_products", ["user_id"], name: "index_monitoring_products_on_user_id", using: :btree

  create_table "operations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
  end

  create_table "parameters", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_capital_accounts", force: true do |t|
    t.integer  "product_id"
    t.integer  "capital_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_capital_accounts", ["capital_account_id"], name: "index_product_capital_accounts_on_capital_account_id", using: :btree
  add_index "product_capital_accounts", ["product_id"], name: "index_product_capital_accounts_on_product_id", using: :btree

  create_table "product_risk_parameters", force: true do |t|
    t.integer  "product_id"
    t.integer  "parameter_id"
    t.decimal  "value",        precision: 20, scale: 4
    t.datetime "happened_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_risk_parameters", ["parameter_id"], name: "index_product_risk_parameters_on_parameter_id", using: :btree
  add_index "product_risk_parameters", ["product_id"], name: "index_product_risk_parameters_on_product_id", using: :btree

  create_table "product_risk_plans", force: true do |t|
    t.integer  "product_id"
    t.integer  "risk_plan_id"
    t.boolean  "is_enabled",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_risk_plans", ["product_id"], name: "index_product_risk_plans_on_product_id", using: :btree
  add_index "product_risk_plans", ["risk_plan_id"], name: "index_product_risk_plans_on_risk_plan_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.integer  "budget",     default: 0
    t.integer  "broker_id"
    t.integer  "bank_id"
  end

  add_index "products", ["bank_id"], name: "index_products_on_bank_id", using: :btree
  add_index "products", ["broker_id"], name: "index_products_on_broker_id", using: :btree
  add_index "products", ["client_id"], name: "index_products_on_client_id", using: :btree

  create_table "relation_symbols", force: true do |t|
    t.string   "name"
    t.string   "math"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risk_events", force: true do |t|
    t.integer  "product_id"
    t.datetime "happened_at"
    t.text     "remark"
    t.integer  "operation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "risk_events", ["operation_id"], name: "index_risk_events_on_operation_id", using: :btree
  add_index "risk_events", ["product_id"], name: "index_risk_events_on_product_id", using: :btree

  create_table "risk_plan_operations", force: true do |t|
    t.integer  "risk_plan_id"
    t.integer  "operation_id"
    t.boolean  "is_enabled",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "risk_plan_operations", ["operation_id"], name: "index_risk_plan_operations_on_operation_id", using: :btree
  add_index "risk_plan_operations", ["risk_plan_id"], name: "index_risk_plan_operations_on_risk_plan_id", using: :btree

  create_table "risk_plans", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "created_by_id"
  end

  create_table "thresholds", force: true do |t|
    t.integer  "relation_symbol_id"
    t.decimal  "value",                  precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parameter_id"
    t.integer  "risk_plan_operation_id"
  end

  add_index "thresholds", ["parameter_id"], name: "index_thresholds_on_parameter_id", using: :btree
  add_index "thresholds", ["relation_symbol_id"], name: "index_thresholds_on_relation_symbol_id", using: :btree
  add_index "thresholds", ["risk_plan_operation_id"], name: "index_thresholds_on_risk_plan_operation_id", using: :btree

  create_table "trades", force: true do |t|
    t.integer  "instrument_id"
    t.decimal  "trade_price",        precision: 20, scale: 4
    t.integer  "order_side",                                  default: 0
    t.integer  "trading_account_id"
    t.datetime "traded_at"
    t.integer  "trade_volume"
    t.integer  "open_close",                                  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "open_volume",                                 default: 0
  end

  add_index "trades", ["instrument_id"], name: "index_trades_on_instrument_id", using: :btree
  add_index "trades", ["trading_account_id"], name: "index_trades_on_trading_account_id", using: :btree

  create_table "trading_accounts", force: true do |t|
    t.string   "name"
    t.decimal  "budget",     precision: 20, scale: 4
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_accounts", ["product_id"], name: "index_trading_accounts_on_product_id", using: :btree

  create_table "translations", force: true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                   default: "", null: false
    t.string   "encrypted_password",      default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "full_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "attachment_access_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
