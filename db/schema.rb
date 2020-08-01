# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_27_014553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.bigint "time_report_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["time_report_id"], name: "index_comments_on_time_report_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "experience_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "time_report_id"
    t.integer "experience_point", null: false
    t.float "bonus_multiplier", default: 1.0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["time_report_id"], name: "index_experience_records_on_time_report_id"
    t.index ["user_id"], name: "index_experience_records_on_user_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "level", default: 1, null: false
    t.integer "total_experience", default: 0, null: false
    t.integer "experience_to_next", default: 50, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_experiences_on_user_id"
  end

  create_table "hash_locks", force: :cascade do |t|
    t.string "table", null: false
    t.string "column", null: false
    t.string "key", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["table", "column", "key"], name: "index_hash_locks_on_table_and_column_and_key", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type"
    t.bigint "likeable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "notices", force: :cascade do |t|
    t.integer "action_user_id", null: false
    t.integer "received_user_id", null: false
    t.string "noticeable_type"
    t.bigint "noticeable_id"
    t.string "like_type"
    t.integer "time_report_id"
    t.boolean "checked", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["noticeable_type", "noticeable_id"], name: "index_notices_on_noticeable_type_and_noticeable_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "required_exps", force: :cascade do |t|
    t.integer "level", null: false
    t.integer "required_exp", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_experience", null: false
    t.index ["level"], name: "index_required_exps_on_level", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "comment_notice", default: true
    t.boolean "comment_like_notice", default: true
    t.boolean "time_report_like_notice", default: true
    t.boolean "follow_notice", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "time_report_tag_links", force: :cascade do |t|
    t.bigint "time_report_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_time_report_tag_links_on_tag_id"
    t.index ["time_report_id", "tag_id"], name: "index_time_report_tag_links_on_time_report_id_and_tag_id", unique: true
    t.index ["time_report_id"], name: "index_time_report_tag_links_on_time_report_id"
  end

  create_table "time_reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.time "study_time", null: false
    t.text "memo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "study_date", null: false
    t.index ["user_id"], name: "index_time_reports_on_user_id"
  end

  create_table "user_tag_relationships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_user_tag_relationships_on_tag_id"
    t.index ["user_id", "tag_id"], name: "user_tag_relationships_unique_index  ", unique: true
    t.index ["user_id"], name: "index_user_tag_relationships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "uid"
    t.string "screen_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "profile"
    t.index "lower((email)::text)", name: "index_users_on_LOWER_email", unique: true
    t.index ["screen_name"], name: "index_users_on_screen_name", unique: true
  end

  create_table "weekly_target_experience_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "weekly_target_id", null: false
    t.integer "experience_point", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_weekly_target_experience_records_on_user_id"
    t.index ["weekly_target_id"], name: "index_weekly_target_experience_records_on_weekly_target_id"
  end

  create_table "weekly_targets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_date", default: "2020-07-26 15:00:00"
    t.datetime "end_date", default: "2020-08-02 14:59:59"
    t.boolean "achieve", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "checked", default: false
    t.datetime "target_time", default: "2000-01-01 00:00:00"
    t.datetime "progress", default: "2000-01-01 00:00:00"
    t.index ["user_id", "checked"], name: "index_weekly_targets_on_user_id_and_checked"
    t.index ["user_id", "start_date", "end_date"], name: "index_weekly_targets_on_user_id_and_start_date_and_end_date", unique: true
    t.index ["user_id"], name: "index_weekly_targets_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "time_reports"
  add_foreign_key "comments", "users"
  add_foreign_key "experience_records", "time_reports"
  add_foreign_key "experience_records", "users"
  add_foreign_key "experiences", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "settings", "users"
  add_foreign_key "time_reports", "users"
  add_foreign_key "user_tag_relationships", "users"
  add_foreign_key "weekly_target_experience_records", "users"
  add_foreign_key "weekly_target_experience_records", "weekly_targets"
  add_foreign_key "weekly_targets", "users"
end
