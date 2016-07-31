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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160715110657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "amenities", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "amenities", ["name"], name: "index_amenities_on_name", unique: true, using: :btree

  create_table "bookers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "address",                             null: false
    t.string   "telephone",                           null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "bookers", ["email"], name: "index_bookers_on_email", unique: true, using: :btree
  add_index "bookers", ["reset_password_token"], name: "index_bookers_on_reset_password_token", unique: true, using: :btree

  create_table "bookings", force: :cascade do |t|
    t.integer  "booker_id"
    t.integer  "pitch_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bookings", ["booker_id"], name: "index_bookings_on_booker_id", using: :btree
  add_index "bookings", ["end_date"], name: "index_bookings_on_end_date", using: :btree
  add_index "bookings", ["pitch_id", "start_date", "end_date"], name: "index_bookings_on_pitch_id_and_start_date_and_end_date", order: {"end_date"=>:desc}, using: :btree
  add_index "bookings", ["pitch_id"], name: "index_bookings_on_pitch_id", using: :btree
  add_index "bookings", ["start_date"], name: "index_bookings_on_start_date", using: :btree

  create_table "owners", force: :cascade do |t|
    t.string   "email",                  default: "",               null: false
    t.string   "encrypted_password",     default: "",               null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "name",                                              null: false
    t.string   "address1",                                          null: false
    t.string   "address2"
    t.string   "address3"
    t.string   "country",                default: "United Kingdom", null: false
    t.string   "county",                                            null: false
    t.string   "city",                                              null: false
    t.string   "town",                                              null: false
    t.string   "postcode",                                          null: false
    t.string   "telephone",                                         null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "owners", ["email"], name: "index_owners_on_email", unique: true, using: :btree
  add_index "owners", ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true, using: :btree

  create_table "pitch_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pitch_types", ["name"], name: "index_pitch_types_on_name", unique: true, using: :btree

  create_table "pitches", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "pitch_type_id"
    t.string   "name"
    t.integer  "max_persons"
    t.float    "length"
    t.float    "width"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "pitches", ["max_persons"], name: "index_pitches_on_max_persons", using: :btree
  add_index "pitches", ["pitch_type_id"], name: "index_pitches_on_pitch_type_id", using: :btree
  add_index "pitches", ["site_id"], name: "index_pitches_on_site_id", using: :btree

  create_table "rates", force: :cascade do |t|
    t.integer  "pitch_id"
    t.date     "from_date"
    t.date     "to_date"
    t.decimal  "amount",     precision: 8, scale: 2
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "rates", ["amount"], name: "index_rates_on_amount", using: :btree
  add_index "rates", ["from_date"], name: "index_rates_on_from_date", using: :btree
  add_index "rates", ["pitch_id"], name: "index_rates_on_pitch_id", using: :btree
  add_index "rates", ["to_date"], name: "index_rates_on_to_date", using: :btree

  create_table "site_amenities", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "amenity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "site_amenities", ["amenity_id"], name: "index_site_amenities_on_amenity_id", using: :btree
  add_index "site_amenities", ["site_id"], name: "index_site_amenities_on_site_id", using: :btree

  create_table "site_images", force: :cascade do |t|
    t.integer  "site_id"
    t.string   "content_file_name"
    t.string   "content_content_type"
    t.integer  "content_file_size"
    t.datetime "content_updated_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "site_images", ["site_id"], name: "index_site_images_on_site_id", using: :btree

  create_table "site_types", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "site_types", ["name"], name: "index_site_types_on_name", unique: true, using: :btree

  create_table "sites", force: :cascade do |t|
    t.integer   "owner_id"
    t.integer   "site_type_id"
    t.string    "name",                                                                                                        null: false
    t.string    "address1",                                                                                                    null: false
    t.string    "address2"
    t.string    "address3"
    t.string    "country",                                                                          default: "United Kingdom", null: false
    t.string    "county",                                                                                                      null: false
    t.string    "city",                                                                                                        null: false
    t.string    "town",                                                                                                        null: false
    t.string    "postcode",                                                                                                    null: false
    t.string    "telephone",                                                                                                   null: false
    t.string    "email",                                                                                                       null: false
    t.geography "coordinates",             limit: {:srid=>4326, :type=>"point", :geographic=>true},                            null: false
    t.string    "general_desc",                                                                                                null: false
    t.string    "detailed_desc",                                                                                               null: false
    t.time      "arrival_time",                                                                                                null: false
    t.time      "departure_time",                                                                                              null: false
    t.string    "main_image_file_name"
    t.string    "main_image_content_type"
    t.integer   "main_image_file_size"
    t.datetime  "main_image_updated_at"
    t.datetime  "created_at",                                                                                                  null: false
    t.datetime  "updated_at",                                                                                                  null: false
  end

  add_index "sites", ["coordinates"], name: "index_sites_on_coordinates", using: :gist
  add_index "sites", ["name", "owner_id"], name: "index_sites_on_name_and_owner_id", unique: true, using: :btree
  add_index "sites", ["owner_id"], name: "index_sites_on_owner_id", using: :btree
  add_index "sites", ["site_type_id"], name: "index_sites_on_site_type_id", using: :btree

  add_foreign_key "bookings", "bookers"
  add_foreign_key "bookings", "pitches"
  add_foreign_key "pitches", "pitch_types"
  add_foreign_key "pitches", "sites"
  add_foreign_key "rates", "pitches"
  add_foreign_key "site_amenities", "amenities"
  add_foreign_key "site_amenities", "sites"
  add_foreign_key "site_images", "sites"
  add_foreign_key "sites", "owners"
  add_foreign_key "sites", "site_types"
end
