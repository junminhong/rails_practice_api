# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_28_155457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pharmacy_store_masks", force: :cascade do |t|
    t.integer "pharmacy_store_id"
    t.string "pharmacy_mask_name"
    t.float "pharmacy_mask_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pharmacy_store_open_times", force: :cascade do |t|
    t.integer "pharmacy_store_id"
    t.string "week"
    t.time "open_time"
    t.time "close_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pharmacy_stores", force: :cascade do |t|
    t.string "name"
    t.float "cash_balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "todos", force: :cascade do |t|
    t.integer "index"
    t.string "title"
    t.boolean "complete"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_purchase_histories", force: :cascade do |t|
    t.integer "user_id"
    t.string "pharmacy_name"
    t.string "mask_name"
    t.float "transaction_amount"
    t.datetime "transaction_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.float "cash_balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
