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

ActiveRecord::Schema.define(version: 20150416091311) do

  create_table "banks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brokers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "capital_accounts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.decimal  "budget",                 precision: 20, scale: 4
    t.integer  "client_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "capital_accounts", ["client_id"], name: "index_capital_accounts_on_client_id", using: :btree

  create_table "clearing_prices", force: :cascade do |t|
    t.integer  "instrument_id",            limit: 4
    t.decimal  "price",                                precision: 20, scale: 4
    t.string   "exchange_instrument_code", limit: 255
    t.datetime "cleared_at"
    t.string   "exchange_code",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clearing_prices", ["instrument_id"], name: "index_clearing_prices_on_instrument_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_number", limit: 255
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "code",          limit: 255
    t.string   "symbol",        limit: 255
    t.decimal  "exchange_rate",             precision: 20, scale: 4
    t.boolean  "is_major",      limit: 1,                            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchanges", force: :cascade do |t|
    t.string   "trading_code",  limit: 255
    t.string   "type",          limit: 255
    t.string   "full_cn_name",  limit: 255
    t.string   "short_cn_name", limit: 255
    t.string   "full_en_name",  limit: 255
    t.string   "short_en_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_unit", limit: 255
  end

  create_table "instruments", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.datetime "expiration_date"
    t.decimal  "strike_price",                         precision: 20, scale: 4
    t.integer  "exchange_id",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trading_symbol_id",        limit: 4
    t.string   "exchange_instrument_code", limit: 255
    t.integer  "instrument_type",          limit: 4
  end

  add_index "instruments", ["exchange_id"], name: "index_instruments_on_exchange_id", using: :btree
  add_index "instruments", ["trading_symbol_id"], name: "index_instruments_on_trading_symbol_id", using: :btree

  create_table "margins", force: :cascade do |t|
    t.string   "type",       limit: 255
    t.decimal  "factor",                 precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_prices", force: :cascade do |t|
    t.integer  "instrument_id",            limit: 4
    t.decimal  "price",                                precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exchange_id",              limit: 4
    t.datetime "exchange_updated_at"
    t.string   "exchange_instrument_code", limit: 255
    t.string   "exchange_code",            limit: 255
  end

  add_index "market_prices", ["exchange_id"], name: "index_market_prices_on_exchange_id", using: :btree
  add_index "market_prices", ["instrument_id"], name: "index_market_prices_on_instrument_id", using: :btree

  create_table "monitoring_products", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monitoring_products", ["product_id"], name: "index_monitoring_products_on_product_id", using: :btree
  add_index "monitoring_products", ["user_id"], name: "index_monitoring_products_on_user_id", using: :btree

  create_table "operations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level",      limit: 4
  end

  create_table "parameters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "position_close_records", force: :cascade do |t|
    t.integer  "open_trade_id",  limit: 4
    t.integer  "close_trade_id", limit: 4
    t.integer  "close_volume",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "position_close_records", ["close_trade_id"], name: "index_position_close_records_on_close_trade_id", using: :btree
  add_index "position_close_records", ["open_trade_id"], name: "index_position_close_records_on_open_trade_id", using: :btree

  create_table "product_capital_accounts", force: :cascade do |t|
    t.integer  "product_id",         limit: 4
    t.integer  "capital_account_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_capital_accounts", ["capital_account_id"], name: "index_product_capital_accounts_on_capital_account_id", using: :btree
  add_index "product_capital_accounts", ["product_id"], name: "index_product_capital_accounts_on_product_id", using: :btree

  create_table "product_risk_parameters", force: :cascade do |t|
    t.integer  "product_id",   limit: 4
    t.integer  "parameter_id", limit: 4
    t.decimal  "value",                  precision: 20, scale: 4
    t.datetime "happened_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_risk_parameters", ["parameter_id"], name: "index_product_risk_parameters_on_parameter_id", using: :btree
  add_index "product_risk_parameters", ["product_id"], name: "index_product_risk_parameters_on_product_id", using: :btree

  create_table "product_risk_plans", force: :cascade do |t|
    t.integer  "product_id",   limit: 4
    t.integer  "risk_plan_id", limit: 4
    t.boolean  "is_enabled",   limit: 1,   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",         limit: 255, default: "ProductRiskPlan"
    t.datetime "begun_at"
    t.datetime "ended_at"
  end

  add_index "product_risk_plans", ["product_id"], name: "index_product_risk_plans_on_product_id", using: :btree
  add_index "product_risk_plans", ["risk_plan_id"], name: "index_product_risk_plans_on_risk_plan_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id",  limit: 4
    t.integer  "budget",     limit: 4,   default: 0
    t.integer  "broker_id",  limit: 4
    t.integer  "bank_id",    limit: 4
  end

  add_index "products", ["bank_id"], name: "index_products_on_bank_id", using: :btree
  add_index "products", ["broker_id"], name: "index_products_on_broker_id", using: :btree
  add_index "products", ["client_id"], name: "index_products_on_client_id", using: :btree

  create_table "relation_symbols", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "math",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risk_events", force: :cascade do |t|
    t.integer  "product_id",   limit: 4
    t.datetime "happened_at"
    t.text     "remark",       limit: 65535
    t.integer  "operation_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "risk_events", ["operation_id"], name: "index_risk_events_on_operation_id", using: :btree
  add_index "risk_events", ["product_id"], name: "index_risk_events_on_product_id", using: :btree

  create_table "risk_plan_operations", force: :cascade do |t|
    t.integer  "risk_plan_id", limit: 4
    t.integer  "operation_id", limit: 4
    t.boolean  "is_enabled",   limit: 1, default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "risk_plan_operations", ["operation_id"], name: "index_risk_plan_operations_on_operation_id", using: :btree
  add_index "risk_plan_operations", ["risk_plan_id"], name: "index_risk_plan_operations_on_risk_plan_id", using: :btree

  create_table "risk_plans", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",          limit: 255
    t.integer  "created_by_id", limit: 4
  end

  create_table "thresholds", force: :cascade do |t|
    t.integer  "relation_symbol_id",     limit: 4
    t.decimal  "value",                            precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parameter_id",           limit: 4
    t.integer  "risk_plan_operation_id", limit: 4
  end

  add_index "thresholds", ["parameter_id"], name: "index_thresholds_on_parameter_id", using: :btree
  add_index "thresholds", ["relation_symbol_id"], name: "index_thresholds_on_relation_symbol_id", using: :btree
  add_index "thresholds", ["risk_plan_operation_id"], name: "index_thresholds_on_risk_plan_operation_id", using: :btree

  create_table "trades", force: :cascade do |t|
    t.integer  "instrument_id",                  limit: 4
    t.decimal  "traded_price",                               precision: 20, scale: 4
    t.integer  "order_side",                     limit: 4,                            default: 0
    t.integer  "trading_account_id",             limit: 4
    t.datetime "exchange_traded_at"
    t.integer  "traded_volume",                  limit: 4
    t.integer  "open_close",                     limit: 4,                            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "open_volume",                    limit: 4,                            default: 0
    t.integer  "exchange_id",                    limit: 4
    t.string   "exchange_trade_id",              limit: 255
    t.integer  "exchange_trade_sequence_number", limit: 4,                            default: 0
    t.string   "trading_account_number",         limit: 255
    t.string   "exchange_code",                  limit: 255
    t.string   "exchange_instrument_code",       limit: 255
    t.decimal  "exchange_margin",                            precision: 20, scale: 4, default: 0.0
    t.decimal  "system_calculated_margin",                   precision: 20, scale: 4, default: 0.0
    t.decimal  "exchange_trading_fee",                       precision: 20, scale: 4, default: 0.0
    t.decimal  "system_calculated_trading_fee",              precision: 20, scale: 4, default: 0.0
    t.integer  "system_trade_sequence_number",   limit: 4,                            default: 0
  end

  add_index "trades", ["exchange_id"], name: "index_trades_on_exchange_id", using: :btree
  add_index "trades", ["instrument_id"], name: "index_trades_on_instrument_id", using: :btree
  add_index "trades", ["trading_account_id"], name: "index_trades_on_trading_account_id", using: :btree

  create_table "trading_account_budget_records", force: :cascade do |t|
    t.integer  "trading_account_id", limit: 4
    t.string   "budget_type",        limit: 255
    t.decimal  "money",                          precision: 20, scale: 4, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_budget_records", ["trading_account_id"], name: "index_trading_account_budget_records_on_trading_account_id", using: :btree

  create_table "trading_account_instruments", force: :cascade do |t|
    t.integer  "trading_account_id", limit: 4
    t.integer  "instrument_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_instruments", ["instrument_id"], name: "index_trading_account_instruments_on_instrument_id", using: :btree
  add_index "trading_account_instruments", ["trading_account_id"], name: "index_trading_account_instruments_on_trading_account_id", using: :btree

  create_table "trading_account_parameters", force: :cascade do |t|
    t.integer  "trading_account_id", limit: 4
    t.string   "parameter_name",     limit: 255
    t.decimal  "parameter_value",                precision: 20, scale: 4, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_parameters", ["trading_account_id"], name: "index_trading_account_parameters_on_trading_account_id", using: :btree

  create_table "trading_account_risk_plans", force: :cascade do |t|
    t.integer  "trading_account_id", limit: 4
    t.integer  "risk_plan_id",       limit: 4
    t.boolean  "is_enabled",         limit: 1,   default: true
    t.datetime "begun_at"
    t.datetime "ended_at"
    t.string   "type",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_risk_plans", ["risk_plan_id"], name: "index_trading_account_risk_plans_on_risk_plan_id", using: :btree
  add_index "trading_account_risk_plans", ["trading_account_id"], name: "index_trading_account_risk_plans_on_trading_account_id", using: :btree

  create_table "trading_account_trading_summaries", force: :cascade do |t|
    t.integer  "trading_account_id", limit: 4
    t.integer  "trading_summary_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_account_trading_summaries", ["trading_account_id"], name: "index_trading_account_trading_summaries_on_trading_account_id", using: :btree
  add_index "trading_account_trading_summaries", ["trading_summary_id"], name: "index_trading_account_trading_summaries_on_trading_summary_id", using: :btree

  create_table "trading_accounts", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "product_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_number", limit: 255
    t.string   "password",       limit: 255
    t.string   "legal_id",       limit: 255
    t.integer  "client_id",      limit: 4
  end

  add_index "trading_accounts", ["client_id"], name: "index_trading_accounts_on_client_id", using: :btree
  add_index "trading_accounts", ["product_id"], name: "index_trading_accounts_on_product_id", using: :btree

  create_table "trading_fees", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.decimal  "factor",                  precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id", limit: 4
  end

  create_table "trading_summaries", force: :cascade do |t|
    t.string   "type",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "trading_date"
    t.integer  "exchange_id",        limit: 4
    t.integer  "latest_trade_id",    limit: 4
    t.integer  "trading_account_id", limit: 4
  end

  add_index "trading_summaries", ["exchange_id"], name: "index_trading_summaries_on_exchange_id", using: :btree
  add_index "trading_summaries", ["latest_trade_id"], name: "index_trading_summaries_on_latest_trade_id", using: :btree
  add_index "trading_summaries", ["trading_account_id"], name: "index_trading_summaries_on_trading_account_id", using: :btree

  create_table "trading_summary_parameters", force: :cascade do |t|
    t.integer  "trading_summary_id", limit: 4
    t.string   "parameter_name",     limit: 255
    t.decimal  "parameter_value",                precision: 20, scale: 4, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_summary_parameters", ["trading_summary_id"], name: "index_trading_summary_parameters_on_trading_summary_id", using: :btree

  create_table "trading_symbol_margins", force: :cascade do |t|
    t.integer  "trading_symbol_id", limit: 4
    t.integer  "margin_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_symbol_margins", ["margin_id"], name: "index_trading_symbol_margins_on_margin_id", using: :btree
  add_index "trading_symbol_margins", ["trading_symbol_id"], name: "index_trading_symbol_margins_on_trading_symbol_id", using: :btree

  create_table "trading_symbol_trading_fees", force: :cascade do |t|
    t.integer  "trading_symbol_id", limit: 4
    t.integer  "trading_fee_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trading_symbol_trading_fees", ["trading_fee_id"], name: "index_trading_symbol_trading_fees_on_trading_fee_id", using: :btree
  add_index "trading_symbol_trading_fees", ["trading_symbol_id"], name: "index_trading_symbol_trading_fees_on_trading_symbol_id", using: :btree

  create_table "trading_symbols", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.integer  "exchange_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id",         limit: 4
    t.decimal  "multiplier",                      precision: 20, scale: 4
    t.integer  "trading_symbol_type", limit: 4
  end

  add_index "trading_symbols", ["currency_id"], name: "index_trading_symbols_on_currency_id", using: :btree
  add_index "trading_symbols", ["exchange_id"], name: "index_trading_symbols_on_exchange_id", using: :btree

  create_table "translations", force: :cascade do |t|
    t.string   "locale",         limit: 255
    t.string   "key",            limit: 255
    t.text     "value",          limit: 65535
    t.text     "interpolations", limit: 65535
    t.boolean  "is_proc",        limit: 1,     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upload_files", force: :cascade do |t|
    t.string   "data_file_file_name",     limit: 255
    t.string   "data_file_content_type",  limit: 255
    t.integer  "data_file_file_size",     limit: 4
    t.datetime "data_file_updated_at"
    t.string   "attachment_access_token", limit: 255
    t.string   "meta_data",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                   limit: 255, default: "", null: false
    t.string   "encrypted_password",      limit: 255, default: "", null: false
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",      limit: 255
    t.string   "last_sign_in_ip",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                    limit: 255
    t.string   "full_name",               limit: 255
    t.string   "avatar_file_name",        limit: 255
    t.string   "avatar_content_type",     limit: 255
    t.integer  "avatar_file_size",        limit: 4
    t.datetime "avatar_updated_at"
    t.string   "attachment_access_token", limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
