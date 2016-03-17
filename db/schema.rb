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

ActiveRecord::Schema.define(version: 20160316163621) do

  create_table "answer_options", force: :cascade do |t|
    t.integer  "question_id", limit: 4,                     null: false
    t.text     "description", limit: 65535,                 null: false
    t.boolean  "is_correct",                default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.string   "user_device_id", limit: 255
    t.text     "google_api_key", limit: 65535
    t.text     "android_id",     limit: 65535
    t.string   "serial_number",  limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "subject_id",  limit: 4,     null: false
    t.text     "description", limit: 65535, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer  "subject_id",          limit: 4,                    null: false
    t.integer  "requester_id",        limit: 4,                    null: false
    t.integer  "opponent_id",         limit: 4
    t.integer  "requester_score",     limit: 4,     default: 0
    t.integer  "opponent_score",      limit: 4,     default: 0
    t.boolean  "requester_available",               default: true
    t.boolean  "opponent_available",                default: true
    t.integer  "opponent_type",       limit: 4,     default: 0
    t.integer  "status",              limit: 4,     default: 0
    t.text     "info",                limit: 65535
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "subject_parents", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "course_id",  limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "name",              limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "subject_parent_id", limit: 4,   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "email",       limit: 255
    t.string   "phone",       limit: 255
    t.string   "city",        limit: 255
    t.string   "api_key",     limit: 255
    t.integer  "api_version", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image_url",   limit: 255
    t.string   "facebook_id", limit: 255
  end

end
