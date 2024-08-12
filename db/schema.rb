# frozen_string_literal: true

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

ActiveRecord::Schema[7.1].define(version: 20_240_806_013_549) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'club_records', force: :cascade do |t|
    t.bigint 'club_id', null: false
    t.bigint 'user_id', null: false
    t.integer 'role'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.boolean 'is_deleted'
    t.index ['club_id'], name: 'index_club_records_on_club_id'
    t.index ['user_id'], name: 'index_club_records_on_user_id'
  end

  create_table 'clubs', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'token'
    t.string 'location'
    t.string 'description'
    t.string 'contact_info'
  end

  create_table 'game_logs', force: :cascade do |t|
    t.bigint 'game_id', null: false
    t.string 'log_record'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['game_id'], name: 'index_game_logs_on_game_id'
  end

  create_table 'games', force: :cascade do |t|
    t.string 'winner'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'state', default: 0
    t.bigint 'table_id'
    t.jsonb 'info', default: {}
    t.index ['table_id'], name: 'index_games_on_table_id'
  end

  create_table 'games_players', force: :cascade do |t|
    t.bigint 'game_id', null: false
    t.bigint 'player_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'number'
    t.integer 'role'
    t.boolean 'alive', default: true
    t.index ['game_id'], name: 'index_games_players_on_game_id'
    t.index ['player_id'], name: 'index_games_players_on_player_id'
  end

  create_table 'tables', force: :cascade do |t|
    t.bigint 'club_id', null: false
    t.string 'token'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'number'
    t.index ['club_id'], name: 'index_tables_on_club_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'nickname'
    t.boolean 'internal', default: false
    t.bigint 'club_id'
    t.string 'provider', default: 'email', null: false
    t.string 'uid', default: '', null: false
    t.json 'tokens'
    t.index ['club_id'], name: 'index_users_on_club_id'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'club_records', 'clubs'
  add_foreign_key 'club_records', 'users'
  add_foreign_key 'game_logs', 'games'
  add_foreign_key 'games', 'tables'
  add_foreign_key 'games_players', 'games'
  add_foreign_key 'games_players', 'users', column: 'player_id'
  add_foreign_key 'tables', 'clubs'
  add_foreign_key 'users', 'clubs'
end
