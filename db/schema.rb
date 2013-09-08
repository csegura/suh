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

ActiveRecord::Schema.define(:version => 20120120204757) do

  create_table "accesses", :force => true do |t|
    t.integer  "user_id",                                     :null => false
    t.integer  "company_id",                                  :null => false
    t.string   "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                    :default => true
    t.string   "email",      :limit => 100
    t.string   "first_name", :limit => 32
    t.string   "last_name",  :limit => 32
  end

  add_index "accesses", ["user_id", "company_id"], :name => "index_accesses_on_user_id_and_company_id", :unique => true

  create_table "activities", :force => true do |t|
    t.integer  "access_id"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "action",       :limit => 32, :default => "created"
    t.string   "info",                       :default => ""
    t.boolean  "private",                    :default => false,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["access_id"], :name => "index_activities_on_access_id"
  add_index "activities", ["company_id"], :name => "index_activities_on_target_company_id"
  add_index "activities", ["subject_id", "subject_type"], :name => "index_activities_on_subject"
  add_index "activities", ["user_id"], :name => "index_activities_on_target_user_id"

  create_table "activity_reads", :force => true do |t|
    t.integer "activity_id"
    t.integer "user_id"
  end

  add_index "activity_reads", ["activity_id", "user_id"], :name => "index_activity_reads_on_activity_id_and_user_id"

  create_table "addresses", :force => true do |t|
    t.string  "name"
    t.string  "line1"
    t.string  "line2"
    t.string  "city",             :limit => 128
    t.string  "state",            :limit => 128
    t.integer "code"
    t.string  "country",          :limit => 128
    t.integer "addressable_id"
    t.string  "addressable_type"
    t.integer "position"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], :name => "index_addresses_on_addresable"

  create_table "avatars", :force => true do |t|
    t.integer  "user_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.integer  "image_file_size"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "company_id"
    t.string   "name",       :limit => 90, :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["company_id"], :name => "index_categories_on_company_id"

  create_table "comments", :force => true do |t|
    t.text     "comment"
    t.integer  "access_id",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "deleted_at"
    t.integer  "company_id"
  end

  add_index "comments", ["access_id"], :name => "index_comments_on_access_id"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable"
  add_index "comments", ["company_id"], :name => "index_comments_on_company_id"

  create_table "companies", :force => true do |t|
    t.string   "name",            :null => false
    t.string   "subdomain"
    t.integer  "main_company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["main_company_id"], :name => "index_companies_on_main_company_id"
  add_index "companies", ["subdomain"], :name => "index_companies_on_subdomain", :unique => true

  create_table "documents", :force => true do |t|
    t.integer  "access_id"
    t.integer  "company_id"
    t.integer  "category_id"
    t.text     "comment"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["access_id"], :name => "index_documents_on_access_id"
  add_index "documents", ["attachable_id", "attachable_type"], :name => "index_documents_on_attachable"
  add_index "documents", ["company_id"], :name => "index_documents_on_company_id"

  create_table "issues", :force => true do |t|
    t.string   "title",                            :null => false
    t.text     "body"
    t.integer  "access_id"
    t.boolean  "open",           :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "closed_by"
    t.datetime "closed_at"
    t.integer  "comments_count", :default => 0
    t.integer  "company_id"
  end

  add_index "issues", ["access_id"], :name => "index_issues_on_access_id"
  add_index "issues", ["closed_by"], :name => "index_issues_on_closed_by"
  add_index "issues", ["company_id"], :name => "index_issues_on_company_id"

# Could not dump table "notes" because of following StandardError
#   Unknown type 'bool' for column 'private'

  create_table "phones", :force => true do |t|
    t.string  "name",           :limit => 32, :null => false
    t.string  "number",         :limit => 32
    t.integer "phoneable_id"
    t.string  "phoneable_type"
    t.integer "position"
  end

  add_index "phones", ["phoneable_id", "phoneable_type"], :name => "index_phones_on_phoneable"

# Could not dump table "sqlite_stat1" because of following StandardError
#   Unknown type '' for column 'tbl'

  create_table "timetracks", :force => true do |t|
    t.integer  "access_id"
    t.integer  "company_id"
    t.text     "body"
    t.boolean  "confirmed",      :default => false
    t.integer  "confirmed_by"
    t.datetime "confirmed_at"
    t.datetime "tracked_at"
    t.datetime "deleted_at"
    t.integer  "minutes"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.boolean  "billable",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tracked_by"
  end

  add_index "timetracks", ["access_id"], :name => "index_timetracks_on_access_id"
  add_index "timetracks", ["trackable_id", "trackable_type"], :name => "index_timetracks_on_trackable"

  create_table "user_profiles", :force => true do |t|
    t.integer "user_id"
    t.string  "title",     :limit => 64
    t.string  "company",   :limit => 64
    t.string  "alt_email", :limit => 64
  end

  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :limit => 100, :null => false
    t.string   "first_name",             :limit => 32
    t.string   "last_name",              :limit => 32
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "last_login_at"
    t.string   "last_login_ip",          :limit => 32
  end

  add_index "users", ["auth_token"], :name => "index_users_on_auth_token"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "writeboard_versions", :force => true do |t|
    t.integer  "access_id"
    t.integer  "company_id"
    t.boolean  "public_access"
    t.boolean  "editable_admins"
    t.boolean  "editable_users"
    t.string   "title"
    t.text     "body"
    t.integer  "writeboard_id"
    t.integer  "versioned_as"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "writeboard_versions", ["versioned_as"], :name => "index_writeboard_versions_on_versioned_as"

  create_table "writeboards", :force => true do |t|
    t.integer  "access_id"
    t.integer  "company_id"
    t.boolean  "public_access",   :default => false
    t.boolean  "editable_admins", :default => false
    t.boolean  "editable_users",  :default => false
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_version"
    t.integer  "version_number",  :default => 0
    t.integer  "version_id"
  end

  add_index "writeboards", ["access_id"], :name => "index_writeboards_on_access_id"
  add_index "writeboards", ["company_id"], :name => "index_writeboards_on_company_id"

end
