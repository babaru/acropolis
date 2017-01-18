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

ActiveRecord::Schema.define(version: 20170118151430) do

  create_table "banks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brokers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "capital_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.index ["product_id"], name: "index_capital_accounts_on_product_id", using: :btree
  end

  create_table "clearing_prices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "instrument_id"
    t.decimal  "price",                    precision: 20, scale: 4
    t.string   "exchange_instrument_code"
    t.datetime "cleared_at"
    t.string   "exchange_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["instrument_id"], name: "index_clearing_prices_on_instrument_id", using: :btree
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_number"
  end

  create_table "currencies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "code"
    t.string   "symbol"
    t.decimal  "exchange_rate", precision: 20, scale: 4
    t.boolean  "is_major",                               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchanges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
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

  create_table "instruments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "expiration_date"
    t.decimal  "strike_price",             precision: 20, scale: 4
    t.integer  "exchange_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "trading_symbol_id"
    t.string   "exchange_instrument_code"
    t.integer  "instrument_type"
    t.index ["exchange_id"], name: "index_instruments_on_exchange_id", using: :btree
    t.index ["trading_symbol_id"], name: "index_instruments_on_trading_symbol_id", using: :btree
  end

  create_table "margins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "type"
    t.decimal  "factor",     precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_prices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "instrument_id"
    t.decimal  "price",                    precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exchange_id"
    t.datetime "exchange_updated_at"
    t.string   "exchange_instrument_code"
    t.string   "exchange_code"
    t.index ["exchange_id"], name: "index_market_prices_on_exchange_id", using: :btree
    t.index ["instrument_id"], name: "index_market_prices_on_instrument_id", using: :btree
  end

  create_table "monitoring_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["product_id"], name: "index_monitoring_products_on_product_id", using: :btree
    t.index ["user_id"], name: "index_monitoring_products_on_user_id", using: :btree
  end

  create_table "operations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
  end

  create_table "parameters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "position_close_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "open_trade_id"
    t.integer  "close_trade_id"
    t.integer  "close_volume"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["close_trade_id"], name: "index_position_close_records_on_close_trade_id", using: :btree
    t.index ["open_trade_id"], name: "index_position_close_records_on_open_trade_id", using: :btree
  end

  create_table "product_capital_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "product_id"
    t.integer  "capital_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["capital_account_id"], name: "index_product_capital_accounts_on_capital_account_id", using: :btree
    t.index ["product_id"], name: "index_product_capital_accounts_on_product_id", using: :btree
  end

  create_table "product_risk_parameters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "product_id"
    t.integer  "parameter_id"
    t.decimal  "value",        precision: 20, scale: 4
    t.datetime "happened_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parameter_id"], name: "index_product_risk_parameters_on_parameter_id", using: :btree
    t.index ["product_id"], name: "index_product_risk_parameters_on_product_id", using: :btree
  end

  create_table "product_risk_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "product_id"
    t.integer  "risk_plan_id"
    t.boolean  "is_enabled",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",         default: "ProductRiskPlan"
    t.datetime "begun_at"
    t.datetime "ended_at"
    t.index ["product_id"], name: "index_product_risk_plans_on_product_id", using: :btree
    t.index ["risk_plan_id"], name: "index_product_risk_plans_on_risk_plan_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relation_symbols", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "math"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risk_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "product_id"
    t.datetime "happened_at"
    t.text     "remark",       limit: 65535
    t.integer  "operation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["operation_id"], name: "index_risk_events_on_operation_id", using: :btree
    t.index ["product_id"], name: "index_risk_events_on_product_id", using: :btree
  end

  create_table "risk_plan_operations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "risk_plan_id"
    t.integer  "operation_id"
    t.boolean  "is_enabled",   default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["operation_id"], name: "index_risk_plan_operations_on_operation_id", using: :btree
    t.index ["risk_plan_id"], name: "index_risk_plan_operations_on_risk_plan_id", using: :btree
  end

  create_table "risk_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "created_by_id"
  end

  create_table "thresholds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "relation_symbol_id"
    t.decimal  "value",                  precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parameter_id"
    t.integer  "risk_plan_operation_id"
    t.index ["parameter_id"], name: "index_thresholds_on_parameter_id", using: :btree
    t.index ["relation_symbol_id"], name: "index_thresholds_on_relation_symbol_id", using: :btree
    t.index ["risk_plan_operation_id"], name: "index_thresholds_on_risk_plan_operation_id", using: :btree
  end

  create_table "trades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
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
    t.decimal  "exchange_margin",                precision: 20, scale: 4, default: "0.0"
    t.decimal  "system_calculated_margin",       precision: 20, scale: 4, default: "0.0"
    t.decimal  "exchange_trading_fee",           precision: 20, scale: 4, default: "0.0"
    t.decimal  "system_calculated_trading_fee",  precision: 20, scale: 4, default: "0.0"
    t.integer  "system_trade_sequence_number",                            default: 0
    t.index ["exchange_id"], name: "index_trades_on_exchange_id", using: :btree
    t.index ["instrument_id"], name: "index_trades_on_instrument_id", using: :btree
    t.index ["trading_account_id"], name: "index_trades_on_trading_account_id", using: :btree
  end

  create_table "trading_account_budget_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_account_id"
    t.string   "budget_type"
    t.decimal  "money",              precision: 20, scale: 4, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["trading_account_id"], name: "index_trading_account_budget_records_on_trading_account_id", using: :btree
  end

  create_table "trading_account_instruments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_account_id"
    t.integer  "instrument_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["instrument_id"], name: "index_trading_account_instruments_on_instrument_id", using: :btree
    t.index ["trading_account_id"], name: "index_trading_account_instruments_on_trading_account_id", using: :btree
  end

  create_table "trading_account_parameters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_account_id"
    t.string   "parameter_name"
    t.decimal  "parameter_value",    precision: 20, scale: 4, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["trading_account_id"], name: "index_trading_account_parameters_on_trading_account_id", using: :btree
  end

  create_table "trading_account_risk_plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_account_id"
    t.integer  "risk_plan_id"
    t.boolean  "is_enabled",         default: true
    t.datetime "begun_at"
    t.datetime "ended_at"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["risk_plan_id"], name: "index_trading_account_risk_plans_on_risk_plan_id", using: :btree
    t.index ["trading_account_id"], name: "index_trading_account_risk_plans_on_trading_account_id", using: :btree
  end

  create_table "trading_account_trading_summaries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_account_id"
    t.integer  "trading_summary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["trading_account_id"], name: "index_trading_account_trading_summaries_on_trading_account_id", using: :btree
    t.index ["trading_summary_id"], name: "index_trading_account_trading_summaries_on_trading_summary_id", using: :btree
  end

  create_table "trading_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account_number"
    t.string   "password"
    t.string   "legal_id"
    t.integer  "client_id"
    t.index ["client_id"], name: "index_trading_accounts_on_client_id", using: :btree
    t.index ["product_id"], name: "index_trading_accounts_on_product_id", using: :btree
  end

  create_table "trading_fees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "type"
    t.decimal  "factor",      precision: 16, scale: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
  end

  create_table "trading_summaries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "trading_date"
    t.integer  "exchange_id"
    t.integer  "latest_trade_id"
    t.integer  "trading_account_id"
    t.index ["exchange_id"], name: "index_trading_summaries_on_exchange_id", using: :btree
    t.index ["latest_trade_id"], name: "index_trading_summaries_on_latest_trade_id", using: :btree
    t.index ["trading_account_id"], name: "index_trading_summaries_on_trading_account_id", using: :btree
  end

  create_table "trading_summary_parameters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_summary_id"
    t.string   "parameter_name"
    t.decimal  "parameter_value",    precision: 20, scale: 4, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["trading_summary_id"], name: "index_trading_summary_parameters_on_trading_summary_id", using: :btree
  end

  create_table "trading_symbol_margins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_symbol_id"
    t.integer  "margin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["margin_id"], name: "index_trading_symbol_margins_on_margin_id", using: :btree
    t.index ["trading_symbol_id"], name: "index_trading_symbol_margins_on_trading_symbol_id", using: :btree
  end

  create_table "trading_symbol_trading_fees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "trading_symbol_id"
    t.integer  "trading_fee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["trading_fee_id"], name: "index_trading_symbol_trading_fees_on_trading_fee_id", using: :btree
    t.index ["trading_symbol_id"], name: "index_trading_symbol_trading_fees_on_trading_symbol_id", using: :btree
  end

  create_table "trading_symbols", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "exchange_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.decimal  "multiplier",          precision: 20, scale: 4
    t.integer  "trading_symbol_type"
    t.index ["currency_id"], name: "index_trading_symbols_on_currency_id", using: :btree
    t.index ["exchange_id"], name: "index_trading_symbols_on_exchange_id", using: :btree
  end

  create_table "translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value",          limit: 65535
    t.text     "interpolations", limit: 65535
    t.boolean  "is_proc",                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upload_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "data_file_file_name"
    t.string   "data_file_content_type"
    t.integer  "data_file_file_size"
    t.datetime "data_file_updated_at"
    t.string   "attachment_access_token"
    t.string   "meta_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
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
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "capital_accounts", "products"
end
