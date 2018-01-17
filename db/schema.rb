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

ActiveRecord::Schema.define(version: 20180117074727) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "assets", force: :cascade do |t|
    t.string "assetable_type"
    t.bigint "assetable_id"
    t.string "asset_file_name"
    t.string "asset_content_type"
    t.integer "asset_file_size"
    t.string "title"
    t.string "alt"
    t.integer "position"
    t.string "type"
    t.string "custom_file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "asset_meta"
    t.index ["assetable_type", "assetable_id"], name: "index_assets_on_assetable_type_and_assetable_id"
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

  create_table "event_invitations", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.integer "state", default: 0
    t.index ["event_id"], name: "index_event_invitations_on_event_id"
    t.index ["user_id"], name: "index_event_invitations_on_user_id"
  end

  create_table "event_participations", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_participations_on_event_id"
    t.index ["user_id"], name: "index_event_participations_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "leisure_category_id"
    t.bigint "leisure_id"
    t.bigint "city_id"
    t.string "title"
    t.string "address"
    t.integer "participants_min"
    t.integer "participants_max"
    t.integer "visibility", default: 0
    t.integer "state", default: 0
    t.integer "affiliation", default: 0
    t.text "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_events_on_city_id"
    t.index ["leisure_category_id"], name: "index_events_on_leisure_category_id"
    t.index ["leisure_id"], name: "index_events_on_leisure_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "title"
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leisure_categories", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key"
  end

  create_table "leisure_interests", force: :cascade do |t|
    t.bigint "leisure_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leisure_id"], name: "index_leisure_interests_on_leisure_id"
    t.index ["user_id"], name: "index_leisure_interests_on_user_id"
  end

  create_table "leisures", force: :cascade do |t|
    t.bigint "leisure_category_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key"
    t.index ["leisure_category_id"], name: "index_leisures_on_leisure_category_id"
  end

  create_table "seos", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "keywords"
    t.text "description"
    t.string "seoable_type"
    t.bigint "seoable_id"
    t.string "param"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seoable_type", "seoable_id"], name: "index_seos_on_seoable_type_and_seoable_id"
  end

  create_table "user_languages", force: :cascade do |t|
    t.bigint "language_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id"], name: "index_user_languages_on_user_id"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "firstname"
    t.string "lastname"
    t.integer "gender"
    t.date "birthdate"
    t.string "phone"
    t.text "description"
    t.boolean "sms_notification", default: false
    t.boolean "email_notification", default: false
    t.boolean "registration_complete", default: false
    t.integer "affiliation", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id"
    t.string "sms_confirmation_token"
    t.datetime "sms_confirmed_at"
    t.datetime "sms_confirmation_sent_at"
    t.integer "verification_state", default: 0
    t.datetime "cgu_accepted_at"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "event_invitations", "events"
  add_foreign_key "event_invitations", "users"
  add_foreign_key "event_participations", "events"
  add_foreign_key "event_participations", "users"
  add_foreign_key "events", "cities"
  add_foreign_key "events", "leisure_categories"
  add_foreign_key "events", "leisures"
  add_foreign_key "events", "users"
  add_foreign_key "leisure_interests", "leisures"
  add_foreign_key "leisure_interests", "users"
  add_foreign_key "leisures", "leisure_categories"
  add_foreign_key "user_languages", "languages"
  add_foreign_key "user_languages", "users"
end
