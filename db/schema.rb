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

ActiveRecord::Schema.define(:version => 20100112151203) do

  create_table "locations", :force => true do |t|
    t.string   "feed"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tz"
    t.string   "old_feed"
  end

  create_table "sample_summaries", :force => true do |t|
    t.datetime "rss_ts"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_summaries", ["location_id"], :name => "index_sample_summaries_on_location_id"

  create_table "samples", :force => true do |t|
    t.datetime "rss_ts"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "sample_summary_id"
  end

  add_index "samples", ["sample_summary_id"], :name => "index_samples_on_sample_summary_id"

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
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
