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

ActiveRecord::Schema.define(:version => 20110825151457) do

  create_table "bank_accounts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "bank_name"
    t.string   "owner_name"
    t.string   "account_no"
    t.string   "blz"
    t.string   "iban"
    t.string   "bic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dashboards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "expenses", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.float    "amount"
    t.date     "date"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "invitee_id"
    t.integer  "inviter_id"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.boolean  "is_bank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.integer  "creditor_user_id"
    t.integer  "debitor_user_id"
    t.float    "amount"
    t.date     "date"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "password_hash"
    t.string   "forename"
    t.string   "surname"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
