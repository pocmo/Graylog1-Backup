# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091006112114) do

  create_table "blacklists", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blacklistterms", :force => true do |t|
    t.string   "message"
    t.datetime "created_at"
    t.integer  "blacklist_id", :default => 0
  end

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.string   "filter_host"
    t.string   "filter_message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "filter_severity"
    t.datetime "filter_date_start"
    t.datetime "filter_date_end"
  end

  create_table "favorites", :force => true do |t|
    t.integer "user_id"
    t.integer "category_id"
  end

  create_table "settings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "geterror_url"
    t.string   "base_url"
    t.string   "dashboard_timespan"
    t.string   "dashboard_messages"
    t.integer  "dashboard_font_size"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "last_activity"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "validmessages", :force => true do |t|
    t.integer  "syslog_message_id"
    t.datetime "created_at"
  end

end
