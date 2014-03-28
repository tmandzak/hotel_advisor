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

ActiveRecord::Schema.define(version: 20140326112939) do

  create_table "addresses", force: true do |t|
    t.integer  "hotel_id"
    t.string   "country"
    t.string   "state"
    t.string   "city"
    t.string   "street"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hotels", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "stars"
    t.boolean  "breakfast"
    t.text     "description"
    t.string   "photo"
    t.decimal  "price"
    t.integer  "rates_count", default: 0
    t.integer  "rates_total", default: 0
    t.decimal  "rate_avg",    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hotels", ["rate_avg", "rates_count"], name: "index_hotels_on_rate_avg_and_rates_count"
  add_index "hotels", ["title"], name: "index_hotels_on_title", unique: true

  create_table "rates", force: true do |t|
    t.integer  "user_id"
    t.integer  "hotel_id"
    t.integer  "rate"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["created_at", "rate"], name: "index_rates_on_created_at_and_rate"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
