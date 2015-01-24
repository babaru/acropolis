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

ActiveRecord::Schema.define(version: 20150124050601) do

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

  create_table "clearing_prices", force: true do |t|
    t.integer  "instrument_id"
    t.decimal  "price",                    precision: 20, scale: 4
    t.string   "exchange_instrument_code"
    t.datetime "cleared_at"
    t.string   "exchange_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clearing_prices", ["instrument_id"], name: "index_clearing_prices_on_instrument_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_number"
  end

  create_table "currencies", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "symbol"
    t.decimal  "exchange_rate", precision: 20, scale: 4
    t.boolean  "is_major",                               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchanges", force: true do |t|
    t.string   "trading_code"
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
    t.datetime "expiration_date"
    t.decimal  "strike_price",             precision: 20, scale: 4
    t.integer  "exchange_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trading_symbol_id"
    t.string   "exchange_instrument_code"
    t.integer  "instrument_type"
  end

  add_index "instruments", ["exchange_id"], name: "index_instruments_on_exchange_id", using: :btree
  add_index "instruments", ["trading_symbol_id"], name: "index_instruments_on_trading_symbol_id", using: :btree

  create_table "margins", force: true do |t|
    t.string   "type"
    t.decimal  "factor",     precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_prices", force: true do |t|
    t.integer  "instrument_id"
    t.decimal  "price",                    precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exchange_id"
    t.datetime "exchange_updated_at"
    t.string   "exchange_instrument_code"
    t.string   "exchange_code"
  end

  add_index "market_prices", ["exchange_id"], name: "index_market_prices_on_exchange_id", using: :btree
  add_index "market_prices", ["instrument_id"], name: "index_market_prices_on_instrument_id", using: :btree

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

  create_table "position_close_records", force: true do |t|
    t.integer  "open_trade_id"
    t.integer  "close_trade_id"
    t.integer  "close_volume"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_close_records", ["close_trade_id"], name: "index_position_close_records_on_close_trade_id", using: :btree
  add_index "position_close_records", ["open_trade_id"], name: "index_position_close_records_on_open_trade_id", using: :btree

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
    t.string   "type",         default: "ProductRiskPlan"
    t.datetime "begun_at"
    t.datetime "ended_at"
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
    t.decimal  "traded_price",                   precision: 20, scale: 4
    t.integer  "order_side",                                              default: 0
    t.integer  "trading_account_id"
    t.datetime "exchange_traded_at"
    t.integer  "traded_volume"
    t.integer  "open_close",                                              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "open_volume",                                             default: 0
    t.integer  "exchange_id"
    t.string   "exchange_trade_id"
    t.integer  "exchange_trade_sequence_number",                          default: 0
    t.string   "trading_account_number"
    t.string   "exchange_code"
    t.string   "exchange_instrument_code"
    t.decimal  "exchange_margin",                precision: 20, scale: 4, default: 0.0
    t.decimal  "system_calculated_margin",       precision: 20, scale: 4, default: 0.0
    t.decimal  "exchange_trading_fee",           precision: 20, scale: 4, default: 0.0
    t.decimal  "system_calculated_trading_fee",  precision: 20, scale: 4, default: 0.0
    t.integer  "system_trade_sequence_number",                            default: 0
  end

  add_index "trades", ["exchange_id"], name: "index_trades_on_exchange_id", using: :btree
  add_index "trades", ["instrument_id"], name: "index_trades_on_instrument_id", using: :btree
  add_index "trades", ["trading_account_id"], name: "index_trades_on_trading_account_id", using: :btree

  create_table "trading_account_budget_records", force: true do |t|
    t.integer  "trading_account_id"
    t.string   "type"
    t.decimal  "money",              precision: 20, scale: 4, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_budget_records", ["trading_account_id"], name: "index_trading_account_budget_records_on_trading_account_id", using: :btree

  create_table "trading_account_instruments", force: true do |t|
    t.integer  "trading_account_id"
    t.integer  "instrument_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_instruments", ["instrument_id"], name: "index_trading_account_instruments_on_instrument_id", using: :btree
  add_index "trading_account_instruments", ["trading_account_id"], name: "index_trading_account_instruments_on_trading_account_id", using: :btree

  create_table "trading_account_parameters", force: true do |t|
    t.integer  "trading_account_id"
    t.string   "parameter_name"
    t.decimal  "parameter_value",    precision: 20, scale: 4, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_parameters", ["trading_account_id"], name: "index_trading_account_parameters_on_trading_account_id", using: :btree

  create_table "trading_account_risk_plans", force: true do |t|
    t.integer  "trading_account_id"
    t.integer  "risk_plan_id"
    t.boolean  "is_enabled",         default: true
    t.datetime "begun_at"
    t.datetime "ended_at"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_risk_plans", ["risk_plan_id"], name: "index_trading_account_risk_plans_on_risk_plan_id", using: :btree
  add_index "trading_account_risk_plans", ["trading_account_id"], name: "index_trading_account_risk_plans_on_trading_account_id", using: :btree

  create_table "trading_account_trading_summaries", force: true do |t|
    t.integer  "trading_account_id"
    t.integer  "trading_summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_trading_summaries", ["trading_account_id"], name: "index_trading_account_trading_summaries_on_trading_account_id", using: :btree
  add_index "trading_account_trading_summaries", ["trading_summary_id"], name: "index_trading_account_trading_summaries_on_trading_summary_id", using: :btree

  create_table "trading_accounts", force: true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_number"
    t.string   "password"
    t.string   "legal_id"
    t.integer  "client_id"
  end

  add_index "trading_accounts", ["client_id"], name: "index_trading_accounts_on_client_id", using: :btree
  add_index "trading_accounts", ["product_id"], name: "index_trading_accounts_on_product_id", using: :btree

  create_table "trading_fees", force: true do |t|
    t.string   "type"
    t.decimal  "factor",      precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
  end

  create_table "trading_summaries", force: true do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "trading_date"
    t.integer  "exchange_id"
    t.integer  "latest_trade_id"
    t.integer  "trading_account_id"
  end

  add_index "trading_summaries", ["exchange_id"], name: "index_trading_summaries_on_exchange_id", using: :btree
  add_index "trading_summaries", ["latest_trade_id"], name: "index_trading_summaries_on_latest_trade_id", using: :btree
  add_index "trading_summaries", ["trading_account_id"], name: "index_trading_summaries_on_trading_account_id", using: :btree

  create_table "trading_summary_parameters", force: true do |t|
    t.integer  "trading_summary_id"
    t.string   "parameter_name"
    t.decimal  "parameter_value",    precision: 20, scale: 4, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_summary_parameters", ["trading_summary_id"], name: "index_trading_summary_parameters_on_trading_summary_id", using: :btree

  create_table "trading_symbol_margins", force: true do |t|
    t.integer  "trading_symbol_id"
    t.integer  "margin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_symbol_margins", ["margin_id"], name: "index_trading_symbol_margins_on_margin_id", using: :btree
  add_index "trading_symbol_margins", ["trading_symbol_id"], name: "index_trading_symbol_margins_on_trading_symbol_id", using: :btree

  create_table "trading_symbol_trading_fees", force: true do |t|
    t.integer  "trading_symbol_id"
    t.integer  "trading_fee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_symbol_trading_fees", ["trading_fee_id"], name: "index_trading_symbol_trading_fees_on_trading_fee_id", using: :btree
  add_index "trading_symbol_trading_fees", ["trading_symbol_id"], name: "index_trading_symbol_trading_fees_on_trading_symbol_id", using: :btree

  create_table "trading_symbols", force: true do |t|
    t.string   "name"
    t.integer  "exchange_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.decimal  "multiplier",          precision: 20, scale: 4
    t.integer  "trading_symbol_type"
  end

  add_index "trading_symbols", ["currency_id"], name: "index_trading_symbols_on_currency_id", using: :btree
  add_index "trading_symbols", ["exchange_id"], name: "index_trading_symbols_on_exchange_id", using: :btree

  create_table "translations", force: true do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value"
    t.text     "interpolations"
    t.boolean  "is_proc",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upload_files", force: true do |t|
    t.string   "data_file_file_name"
    t.string   "data_file_content_type"
    t.integer  "data_file_file_size"
    t.datetime "data_file_updated_at"
    t.string   "attachment_access_token"
    t.string   "meta_data"
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
