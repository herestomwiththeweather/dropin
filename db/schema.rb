# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_05_03_025117) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string "token"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_access_tokens_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "identifier"
    t.string "secret"
    t.string "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fontsize", precision: 3, scale: 2, default: "1.0"
  end

  create_table "events", force: :cascade do |t|
    t.integer "identifier"
    t.datetime "start_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", default: 0
    t.datetime "last_fetched_at"
    t.bigint "client_id"
  end

  create_table "people", force: :cascade do |t|
    t.integer "identifier"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "client_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["person_id"], name: "index_registrations_on_person_id"
  end

  add_foreign_key "access_tokens", "clients"
  add_foreign_key "registrations", "events"
  add_foreign_key "registrations", "people"
end
