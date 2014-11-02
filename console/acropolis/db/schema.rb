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

ActiveRecord::Schema.define(version: 20141102054853) do

  create_table "clients", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "bank"
    t.string   "broker"
    t.string   "long_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
  end

  add_index "products", ["client_id"], name: "index_products_on_client_id", using: :btree

  create_table "relation_symbols", force: true do |t|
    t.string   "name"
    t.string   "math"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "risk_plans", force: true do |t|
    t.integer  "parameter_id"
    t.integer  "operation_id"
    t.integer  "priority",     default: 5
    t.boolean  "is_enabled",   default: false
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "risk_plans", ["operation_id"], name: "index_risk_plans_on_operation_id", using: :btree
  add_index "risk_plans", ["parameter_id"], name: "index_risk_plans_on_parameter_id", using: :btree
  add_index "risk_plans", ["product_id"], name: "index_risk_plans_on_product_id", using: :btree
  add_index "risk_plans", ["user_id"], name: "index_risk_plans_on_user_id", using: :btree

  create_table "thresholds", force: true do |t|
    t.integer  "risk_plan_id"
    t.integer  "relation_symbol_id"
    t.decimal  "value",              precision: 20, scale: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                        default: "ParameterThreshold"
  end

  add_index "thresholds", ["relation_symbol_id"], name: "index_thresholds_on_relation_symbol_id", using: :btree
  add_index "thresholds", ["risk_plan_id"], name: "index_thresholds_on_risk_plan_id", using: :btree

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
