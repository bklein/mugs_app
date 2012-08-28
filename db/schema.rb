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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120728201545) do

  create_table "bookings", :force => true do |t|
    t.string   "booking_no"
    t.datetime "booking_datetime"
    t.string   "bond"
    t.string   "inmate_name"
    t.string   "inmate_number"
    t.integer  "jail_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "mugshot"
    t.boolean  "is_purchased",     :default => false
    t.boolean  "is_downloaded",    :default => false
  end

  create_table "charges", :force => true do |t|
    t.integer  "booking_id"
    t.string   "charge_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "download_tasks", :force => true do |t|
    t.integer  "jail_id"
    t.string   "booking_id"
    t.string   "remote_filename"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "jails", :force => true do |t|
    t.string   "short_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "full_name"
  end

  create_table "orders", :force => true do |t|
    t.integer  "booking_id"
    t.string   "inmate_name"
    t.string   "email"
    t.boolean  "is_complete",       :default => false
    t.string   "stripe_card_token"
    t.string   "remote_ip"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

end
