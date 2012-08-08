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

ActiveRecord::Schema.define(:version => 20120807120321) do

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.integer  "user_group_id", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "columns", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "board_id"
    t.boolean  "group_by_date"
  end

  create_table "subtasks", :force => true do |t|
    t.string   "content"
    t.integer  "task_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "is_done"
  end

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "time_spent"
    t.integer  "time_estimated"
    t.integer  "user_id"
    t.integer  "subtask_id"
    t.integer  "comment_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "column_id"
  end

  add_index "tasks", ["column_id"], :name => "index_tasks_on_column_id"

  create_table "tasks_users", :id => false, :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "task_id", :null => false
  end

  add_index "tasks_users", ["user_id", "task_id"], :name => "index_tasks_users_on_user_id_and_task_id", :unique => true

  create_table "user_groups", :force => true do |t|
    t.string   "group_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_groups_users", :id => false, :force => true do |t|
    t.integer "user_id",       :null => false
    t.integer "user_group_id", :null => false
  end

  add_index "user_groups_users", ["user_id", "user_group_id"], :name => "index_user_groups_users_on_user_id_and_user_group_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.boolean  "is_admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
