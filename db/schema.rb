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

ActiveRecord::Schema.define(version: 20171130221440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "basic_pages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "position"
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "department_name"
    t.string "department_code", limit: 3
    t.string "name"
    t.string "normalized_name"
    t.string "zipcode", limit: 5
    t.string "insee", limit: 5
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_code"], name: "index_cities_on_department_code"
    t.index ["zipcode"], name: "index_cities_on_zipcode"
  end

  create_table "seos", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "keywords"
    t.text "description"
    t.string "seoable_type"
    t.integer "seoable_id"
    t.string "param"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seoable_type", "seoable_id"], name: "index_seos_on_seoable_type_and_seoable_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "firstname"
    t.string "lastname"
    t.integer "gender"
    t.date "birthdate"
    t.string "phone"
    t.text "description"
    t.boolean "sms_notification", default: false
    t.boolean "email_notification", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
