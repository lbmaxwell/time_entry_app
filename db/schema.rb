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

ActiveRecord::Schema.define(:version => 20120419125652) do

  create_table "assignments", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "assignments", ["role_id"], :name => "index_assignments_on_role_id"
  add_index "assignments", ["team_id"], :name => "index_assignments_on_team_id"
  add_index "assignments", ["user_id"], :name => "index_assignments_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "comment"
    t.integer  "time_entry_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "comments", ["time_entry_id"], :name => "index_comments_on_time_entry_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "paid_time_entries", :force => true do |t|
    t.time     "time"
    t.date     "effective_date"
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "paid_time_entries", ["team_id"], :name => "index_paid_time_entries_on_team_id"
  add_index "paid_time_entries", ["user_id"], :name => "index_paid_time_entries_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "task_inventories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.boolean  "track_count"
  end

  create_table "tasks", :force => true do |t|
    t.boolean  "is_active"
    t.integer  "task_inventory_id"
    t.integer  "team_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "expectation_in_seconds"
  end

  add_index "tasks", ["task_inventory_id"], :name => "index_tasks_on_task_inventory_id"
  add_index "tasks", ["team_id"], :name => "index_tasks_on_team_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "time_entries", :force => true do |t|
    t.integer  "number_processed"
    t.date     "effective_date"
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "seconds"
    t.integer  "team_id"
  end

  add_index "time_entries", ["task_id"], :name => "index_time_entries_on_task_id"
  add_index "time_entries", ["user_id"], :name => "index_time_entries_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "team_id"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
