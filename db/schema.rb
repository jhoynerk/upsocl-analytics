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

ActiveRecord::Schema.define(version: 20180421215339) do

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

  create_table "active_admin_managed_resources", force: :cascade do |t|
    t.string "class_name", null: false
    t.string "action",     null: false
    t.string "name"
  end

  add_index "active_admin_managed_resources", ["class_name", "action", "name"], name: "active_admin_managed_resources_index", unique: true, using: :btree

  create_table "active_admin_permissions", force: :cascade do |t|
    t.integer "managed_resource_id",                       null: false
    t.integer "role",                limit: 2, default: 0, null: false
    t.integer "state",               limit: 2, default: 0, null: false
  end

  add_index "active_admin_permissions", ["managed_resource_id", "role"], name: "active_admin_permissions_index", unique: true, using: :btree

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

  create_table "agencies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "agencies_countries_marks", force: :cascade do |t|
    t.integer "countries_mark_id"
    t.integer "agency_id"
  end

  add_index "agencies_countries_marks", ["agency_id"], name: "index_agencies_countries_marks_on_agency_id", using: :btree
  add_index "agencies_countries_marks", ["countries_mark_id"], name: "index_agencies_countries_marks_on_countries_mark_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "agencies_countries_mark_id"
  end

  create_table "campaigns_tags", force: :cascade do |t|
    t.integer "campaign_id"
    t.integer "tag_id"
  end

  add_index "campaigns_tags", ["campaign_id"], name: "index_campaigns_tags_on_campaign_id", using: :btree
  add_index "campaigns_tags", ["tag_id"], name: "index_campaigns_tags_on_tag_id", using: :btree

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

  create_table "countries_marks", force: :cascade do |t|
    t.integer "country_id"
    t.integer "mark_id"
  end

  add_index "countries_marks", ["country_id"], name: "index_countries_marks_on_country_id", using: :btree
  add_index "countries_marks", ["mark_id"], name: "index_countries_marks_on_mark_id", using: :btree

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
    t.integer  "pageviews",     default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "users",         default: 0
    t.float    "avgtimeonpage", default: 0.0
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
    t.integer  "pageviews",   default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
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
    t.string   "post_id"
    t.integer  "url_id"
    t.integer  "facebook_account_id"
    t.string   "title"
    t.string   "url_video"
    t.integer  "campaign_id"
    t.integer  "interval_status",             default: 0
    t.integer  "total_likes",                 default: 0
    t.integer  "total_comments",              default: 0
    t.integer  "total_shares",                default: 0
    t.float    "post_impressions_unique",     default: 0.0
    t.float    "post_video_avg_time_watched", default: 0.0
    t.float    "post_video_views",            default: 0.0
    t.float    "post_video_view_time",        default: 0.0
    t.datetime "data_updated_at"
    t.boolean  "goal_achieved",               default: false
    t.float    "goal",                        default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "post_video_views_10s",        default: 0.0
    t.integer  "post_impressions",            default: 0
    t.boolean  "original",                    default: false
  end

  add_index "facebook_posts", ["facebook_account_id"], name: "index_facebook_posts_on_facebook_account_id", using: :btree
  add_index "facebook_posts", ["url_id"], name: "index_facebook_posts_on_url_id", using: :btree

  create_table "facebook_posts_tags", force: :cascade do |t|
    t.integer "facebook_post_id"
    t.integer "tag_id"
  end

  add_index "facebook_posts_tags", ["facebook_post_id"], name: "index_facebook_posts_tags_on_facebook_post_id", using: :btree
  add_index "facebook_posts_tags", ["tag_id"], name: "index_facebook_posts_tags_on_tag_id", using: :btree

  create_table "forms", force: :cascade do |t|
    t.string   "name"
    t.string   "last_name"
    t.string   "email"
    t.string   "address"
    t.string   "path_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "message",                 null: false
    t.integer  "status",      default: 0, null: false
    t.integer  "type_update", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "page_stadistics", force: :cascade do |t|
    t.integer  "url_id"
    t.date     "date"
    t.float    "avgtimeonpage", default: 0.0
    t.integer  "pageviews",     default: 0
    t.integer  "sessions",      default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "users",         default: 0
  end

  add_index "page_stadistics", ["url_id"], name: "index_page_stadistics_on_url_id", using: :btree

  create_table "reactions", force: :cascade do |t|
    t.string  "title",  null: false
    t.integer "order",  null: false
    t.string  "avatar", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string  "title"
    t.integer "type_tag", default: 0
  end

  create_table "tags_urls", force: :cascade do |t|
    t.integer "url_id"
    t.integer "tag_id"
  end

  add_index "tags_urls", ["tag_id"], name: "index_tags_urls_on_tag_id", using: :btree
  add_index "tags_urls", ["url_id"], name: "index_tags_urls_on_url_id", using: :btree

  create_table "traffic_stadistics", force: :cascade do |t|
    t.integer  "url_id"
    t.date     "date"
    t.string   "traffic_type"
    t.integer  "pageviews",    default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "traffic_stadistics", ["url_id"], name: "index_traffic_stadistics_on_url_id", using: :btree

  create_table "urls", force: :cascade do |t|
    t.string   "data"
    t.integer  "campaign_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "title"
    t.integer  "line_id"
    t.string   "screenshot"
    t.boolean  "publicity",            default: true
    t.string   "profile_id",           default: "111669814"
    t.integer  "interval_status",      default: 0
    t.integer  "facebook_likes",       default: 0
    t.integer  "facebook_comments",    default: 0
    t.integer  "facebook_shares",      default: 0
    t.float    "attention",            default: 0.0
    t.boolean  "publico",              default: false
    t.date     "publication_date"
    t.date     "publication_end_date"
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
    t.integer  "role",                   default: 0,     null: false
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
