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

ActiveRecord::Schema.define(version: 20_150_908_203_256) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'comments', force: :cascade do |t|
    t.text 'body', null: false
    t.integer 'issue_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'creator_id', null: false
  end

  add_index 'comments', ['issue_id'], name: 'index_comments_on_issue_id', using: :btree

  create_table 'issues', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'description', null: false
    t.integer 'priority', null: false
    t.integer 'status', default: 0, null: false
    t.datetime 'created_at',              null: false
    t.datetime 'updated_at',              null: false
    t.integer 'creator_id', null: false
    t.integer 'assignee_id'
  end

  add_index 'issues', ['priority'], name: 'index_issues_on_priority', using: :btree
  add_index 'issues', ['status'], name: 'index_issues_on_status', using: :btree

  create_table 'users', force: :cascade do |t|
    t.string 'username', null: false
    t.string 'name'
    t.string 'surname'
    t.string 'password_digest', null: false
    t.datetime 'created_at',                  null: false
    t.datetime 'updated_at',                  null: false
    t.integer 'role', default: 0, null: false
  end

  add_index 'users', ['role'], name: 'index_users_on_role', using: :btree

  add_foreign_key 'comments', 'issues'
  add_foreign_key 'comments', 'users', column: 'creator_id'
  add_foreign_key 'issues', 'users', column: 'assignee_id'
  add_foreign_key 'issues', 'users', column: 'creator_id'
end
