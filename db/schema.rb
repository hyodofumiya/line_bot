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

ActiveRecord::Schema.define(version: 2020_06_06_062606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.text "line_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "richmenus", force: :cascade do |t|
    t.string "name", null: false
    t.text "richmenu_id", null: false
    t.string "explanation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standbies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.datetime "start", null: false
    t.datetime "break_start"
    t.integer "break_sum"
    t.index ["user_id"], name: "index_standbies_on_user_id"
  end

  create_table "time_cards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date", null: false
    t.integer "work_time", null: false
    t.datetime "start_time", null: false
    t.datetime "finish_time", null: false
    t.integer "break_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_time_cards_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "family_name", null: false
    t.string "first_name", null: false
    t.integer "employee_number", null: false
    t.text "line_id", null: false
    t.boolean "admin_user", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_number", "line_id"], name: "index_users_on_employee_number_and_line_id", unique: true
  end

  add_foreign_key "standbies", "users", on_delete: :cascade
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
end
