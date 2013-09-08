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

ActiveRecord::Schema.define(:version => 20110822173426) do

  create_table "accesses", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "company_id", :null => false
    t.string "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "active", :default => true
    t.string "first_name", :limit => 32
    t.string "last_name", :limit => 32
  end

  add_index "accesses", ["user_id", "company_id"], :name => "index_accesses_on_user_id_and_company_id", :unique => true

  create_table "addresses", :force => true do |t|
    t.string "name"
    t.string "line1"
    t.string "line2"
    t.string "city", :limit => 128
    t.string "state", :limit => 128
    t.integer "code"
    t.string "country", :limit => 128
    t.integer "addressable_id"
    t.string "addressable_type"
    t.integer "position"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addresable"

  create_table "phones", :force => true do |t|
    t.string "name", :limit => 32
    t.string "number", :limit => 32
    t.integer "phoneable_id"
    t.string "phoneable_type"
    t.integer "position"
  end

  add_index "phones", ["phoneable_id", "phoneable_type"], :name => "index_phones_on_phoneable"

  create_table "notes", :force => true do |t|
    t.string "note"
    t.integer "annotate_id"
    t.string "annotate_type"
    t.timestamps
  end

  add_index "notes", ["annotate_id", "annotate_type"], :name => "index_on_notes_on_annotate"

  create_table "avatars", :force => true do |t|
    t.integer "user_id"
    t.integer "entity_id"
    t.string "entity_type"
    t.integer "image_file_size"
    t.string "image_file_name"
    t.string "image_content_type"
    t.timestamps
  end


  create_table "companies", :force => true do |t|
    t.string "name", :null => false
    t.string "subdomain"
    t.integer "main_company_id"
    t.timestamps
  end

  add_index "companies", ["main_company_id"], :name => "index_companies_on_main_company_id"
  add_index "companies", ["subdomain"], :name => "index_companies_on_subdomain", :unique => true

  create_table "activities", :force => true do |t|
    t.integer "access_id"
    t.integer "target_user_id"
    t.integer "target_company_id"
    t.integer "subject_id"
    t.string "subject_type"
    t.string "action", :limit => 32, :default => "created"
    t.string "info", :default => ""
    t.boolean "private", :default => false, :null => false
    t.timestamps
  end

  add_index "activities", ["access_id"], :name => "index_activities_on_access_id"
  add_index "activities", ["target_user_id"], :name => "index_activities_on_target_user_id"
  add_index "activities", ["target_company_id"], :name => "index_activities_on_target_company_id"
  add_index "activities", ["subject_id", "subject_type"], :name => "index_activities_on_subject"

  create_table "user_profiles", :force => true do |t|
    t.integer "user_id"
    t.string "first_name", :limit => 32
    t.string "last_name", :limit => 32
    t.string "title", :limit => 64
    t.string "company", :limit => 64
    t.string "alt_email", :limit => 64
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.string "email", :null => false
    t.string "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "auth_token"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "last_login_at"
    t.string "last_login_ip", :limit => 32
  end

  add_index "users", ["auth_token"], :name => "index_users_on_auth_token"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
