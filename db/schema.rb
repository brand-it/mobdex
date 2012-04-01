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

ActiveRecord::Schema.define(:version => 20120401074008) do

  create_table "beta_signups", :force => true do |t|
    t.string    "email"
    t.boolean   "excepted",   :default => false
    t.timestamp "created_at",                    :null => false
    t.timestamp "updated_at",                    :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "note"
    t.integer  "feedback_id"
    t.integer  "created_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "domains", :force => true do |t|
    t.text      "url"
    t.string    "title"
    t.text      "description"
    t.timestamp "data_recived_on"
    t.text      "mobile_url"
    t.text      "favicon_path",    :default => "favicon.ico"
    t.timestamp "create_at"
    t.timestamp "updated_at"
    t.integer   "code"
  end

  create_table "feebacks", :force => true do |t|
    t.text     "details"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.text     "note"
    t.integer  "domain_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "created_by"
  end

  create_table "mass_domains", :force => true do |t|
    t.text      "domains"
    t.integer   "parse_type",    :default => 1
    t.boolean   "added",         :default => false
    t.timestamp "added_on"
    t.boolean   "error",         :default => false
    t.text      "error_message"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string    "query"
    t.string    "request_ip"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer   "domain_id"
    t.integer   "tag_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "first_name",                             :null => false
    t.string    "last_name",                              :null => false
    t.string    "email",                                  :null => false
    t.string    "crypted_password",                       :null => false
    t.string    "password_salt",                          :null => false
    t.string    "persistence_token",                      :null => false
    t.string    "single_access_token",                    :null => false
    t.string    "perishable_token",                       :null => false
    t.integer   "login_count",         :default => 0,     :null => false
    t.integer   "failed_login_count",  :default => 0,     :null => false
    t.timestamp "last_request_at"
    t.timestamp "current_login_at"
    t.timestamp "last_login_at"
    t.string    "current_login_ip"
    t.string    "last_login_ip"
    t.integer   "access_level",        :default => 0
    t.boolean   "active",              :default => false
  end

end
