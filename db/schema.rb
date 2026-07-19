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

ActiveRecord::Schema[8.1].define(version: 2026_07_17_155127) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "chats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "health_goal_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["health_goal_id"], name: "index_chats_on_health_goal_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "spot_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["spot_id"], name: "index_favourites_on_spot_id"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "follower_id", null: false
    t.bigint "following_id", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "following_id"], name: "index_follows_on_follower_id_and_following_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
    t.index ["following_id"], name: "index_follows_on_following_id"
  end

  create_table "health_goals", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "module"
    t.string "name"
    t.text "system_prompt"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_health_goals_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "categories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_preferences_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "rating"
    t.bigint "spot_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["spot_id"], name: "index_reviews_on_spot_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "shares", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "spot_id", null: false
    t.string "token"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["spot_id"], name: "index_shares_on_spot_id"
    t.index ["token"], name: "index_shares_on_token", unique: true
    t.index ["user_id"], name: "index_shares_on_user_id"
  end

  create_table "spots", force: :cascade do |t|
    t.string "address"
    t.string "category"
    t.string "city"
    t.datetime "created_at", null: false
    t.text "description"
    t.float "latitude"
    t.float "longitude"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_url"
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "health_goals"
  add_foreign_key "chats", "users"
  add_foreign_key "favourites", "spots"
  add_foreign_key "favourites", "users"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "follows", "users", column: "following_id"
  add_foreign_key "health_goals", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "preferences", "users"
  add_foreign_key "reviews", "spots"
  add_foreign_key "reviews", "users"
  add_foreign_key "shares", "spots"
  add_foreign_key "shares", "users"
  add_foreign_key "spots", "users"
end
