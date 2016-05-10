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

ActiveRecord::Schema.define(version: 20160510174702) do

  create_table "answer_options", force: :cascade do |t|
    t.integer  "question_id", limit: 4,                     null: false
    t.text     "description", limit: 65535,                 null: false
    t.boolean  "is_correct",                default: false, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "answer_options", ["question_id"], name: "index_answer_options_on_question_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "course_parent", limit: 4,   null: false
  end

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.string   "user_device_id", limit: 255
    t.text     "google_api_key", limit: 65535
    t.text     "android_id",     limit: 65535
    t.string   "serial_number",  limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "appversion",     limit: 255
  end

  add_index "devices", ["user_device_id"], name: "index_devices_on_user_device_id", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "subject_id",  limit: 4,     null: false
    t.text     "description", limit: 65535, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "level",       limit: 4,     null: false
  end

  add_index "questions", ["level"], name: "index_questions_on_level", using: :btree
  add_index "questions", ["subject_id"], name: "index_questions_on_subject_id", using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.integer  "subject_id",             limit: 4,                     null: false
    t.integer  "requester_id",           limit: 4,                     null: false
    t.integer  "opponent_id",            limit: 4
    t.integer  "requester_score",        limit: 4,     default: 0
    t.integer  "opponent_score",         limit: 4,     default: 0
    t.boolean  "requester_available",                  default: true
    t.boolean  "opponent_available",                   default: true
    t.boolean  "requester_waiting",                    default: false
    t.boolean  "opponent_waiting",                     default: false
    t.integer  "last_question_answered", limit: 4,     default: 0
    t.integer  "opponent_type",          limit: 4,     default: 0
    t.integer  "status",                 limit: 4,     default: 0
    t.text     "info",                   limit: 65535
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "quizzes", ["created_at"], name: "index_quizzes_on_created_at", using: :btree
  add_index "quizzes", ["subject_id", "status"], name: "index_quizzes_on_subject_id_and_status", using: :btree

  create_table "subject_parents", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "course_id",  limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "subject_parents", ["course_id"], name: "index_subject_parents_on_course_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name",              limit: 255, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "subject_parent_id", limit: 4,   null: false
  end

  add_index "subjects", ["subject_parent_id"], name: "index_subjects_on_subject_parent_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.string   "phone",             limit: 255
    t.string   "city",              limit: 255
    t.string   "api_key",           limit: 255
    t.integer  "api_version",       limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "image_url",         limit: 255
    t.string   "facebook_id",       limit: 255
    t.integer  "total_score",       limit: 4,   default: 0, null: false
    t.integer  "total_quiz_played", limit: 4,   default: 0, null: false
    t.integer  "won",               limit: 4,   default: 0, null: false
    t.integer  "lost",              limit: 4,   default: 0, null: false
    t.datetime "call_request_at"
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
