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

ActiveRecord::Schema.define(version: 20160622150210) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaigns_users", id: false, force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "user_id"
  end

  add_index "campaigns_users", ["campaign_id"], name: "index_campaigns_users_on_campaign_id", using: :btree
  add_index "campaigns_users", ["user_id"], name: "index_campaigns_users_on_user_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries_urls", id: false, force: :cascade do |t|
    t.integer "url_id"
    t.integer "country_id"
  end

  add_index "countries_urls", ["country_id"], name: "index_countries_urls_on_country_id", using: :btree
  add_index "countries_urls", ["url_id"], name: "index_countries_urls_on_url_id", using: :btree

  create_table "country_stadistics", force: :cascade do |t|
    t.integer  "url_id"
    t.date     "date"
    t.string   "country_name"
    t.string   "country_code"
    t.integer  "pageviews"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "users"
    t.float    "avgtimeonpage"
  end

  add_index "country_stadistics", ["url_id"], name: "index_country_stadistics_on_url_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "device_stadistics", force: :cascade do |t|
    t.integer  "url_id"
    t.date     "date"
    t.string   "device_type"
    t.integer  "pageviews"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "device_stadistics", ["url_id"], name: "index_device_stadistics_on_url_id", using: :btree

  create_table "dfp_stadistics", force: :cascade do |t|
    t.integer  "url_id"
    t.date     "date"
    t.string   "line_name"
    t.integer  "line_id"
    t.integer  "impressions"
    t.integer  "clicks"
    t.float    "ctr"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "dfp_stadistics", ["url_id"], name: "index_dfp_stadistics_on_url_id", using: :btree

  create_table "facebook_accounts", force: :cascade do |t|
    t.string "name"
    t.string "facebook_id"
  end

  create_table "facebook_posts", force: :cascade do |t|
    t.string  "post_id"
    t.integer "url_id"
    t.integer "facebook_account_id"
  end

  add_index "facebook_posts", ["facebook_account_id"], name: "index_facebook_posts_on_facebook_account_id", using: :btree
  add_index "facebook_posts", ["url_id"], name: "index_facebook_posts_on_url_id", using: :btree

  create_table "page_stadistics", force: :cascade do |t|
    t.integer  "url_id"
    t.date     "date"
    t.float    "avgtimeonpage"
    t.integer  "pageviews"
    t.integer  "sessions"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "users"
  end

  add_index "page_stadistics", ["url_id"], name: "index_page_stadistics_on_url_id", using: :btree

  create_table "reactions", force: :cascade do |t|
    t.string  "title",               null: false
    t.integer "order",               null: false
    t.string  "avatar",              null: false
    t.integer "facebook_account_id"
  end

  add_index "reactions", ["facebook_account_id"], name: "index_reactions_on_facebook_account_id", using: :btree

  create_table "traffic_stadistics", force: :cascade do |t|
    t.integer  "url_id"
    t.date     "date"
    t.string   "traffic_type"
    t.integer  "pageviews"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "traffic_stadistics", ["url_id"], name: "index_traffic_stadistics_on_url_id", using: :btree

  create_table "urls", force: :cascade do |t|
    t.string   "data"
    t.integer  "campaign_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "title"
    t.integer  "line_id"
    t.string   "screenshot"
    t.boolean  "publicity",       default: true
    t.datetime "data_updated_at"
    t.string   "profile_id",      default: "111669814"
    t.integer  "interval_status", default: 0
  end

  add_index "urls", ["campaign_id"], name: "index_urls_on_campaign_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer "url_id"
    t.integer "reaction_id"
  end

  add_index "votes", ["reaction_id"], name: "index_votes_on_reaction_id", using: :btree
  add_index "votes", ["url_id"], name: "index_votes_on_url_id", using: :btree

end
