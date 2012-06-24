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

ActiveRecord::Schema.define(:version => 20120605193223) do

  create_table "labels", :force => true do |t|
    t.string   "name",                                    :null => false
    t.text     "description"
    t.boolean  "usable_with_questions"
    t.boolean  "usable_with_publications"
    t.boolean  "usable_with_templates"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "lock_version",             :default => 0, :null => false
  end

  add_index "labels", ["name"], :name => "index_labels_on_name"
  add_index "labels", ["usable_with_publications"], :name => "index_labels_on_usable_with_publications"
  add_index "labels", ["usable_with_questions"], :name => "index_labels_on_usable_with_questions"
  add_index "labels", ["usable_with_templates"], :name => "index_labels_on_usable_with_templates"

  create_table "messages", :force => true do |t|
    t.integer  "author_id",                   :null => false
    t.integer  "origin_id"
    t.string   "origin_type"
    t.string   "type",                        :null => false
    t.string   "name",                        :null => false
    t.text     "content"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "messages", ["author_id"], :name => "index_messages_on_author_id"
  add_index "messages", ["origin_id", "origin_type"], :name => "index_messages_on_origin_id_and_origin_type"

  create_table "parameters", :force => true do |t|
    t.string   "name",                                       :null => false
    t.string   "label"
    t.string   "nature",                                     :null => false
    t.string   "document_value_file_name"
    t.integer  "document_value_file_size"
    t.string   "document_value_content_type"
    t.datetime "document_value_updated_at"
    t.string   "document_value_fingerprint"
    t.string   "string_value"
    t.boolean  "boolean_value"
    t.decimal  "decimal_value"
    t.date     "date_value"
    t.datetime "datetime_value"
    t.integer  "record_value_id"
    t.string   "record_value_type"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "lock_version",                :default => 0, :null => false
  end

  add_index "parameters", ["name"], :name => "index_parameters_on_name"
  add_index "parameters", ["nature"], :name => "index_parameters_on_nature"

  create_table "publication_natures", :force => true do |t|
    t.string   "name",                                 :null => false
    t.text     "title_format",                         :null => false
    t.text     "fields"
    t.boolean  "usable",            :default => false, :null => false
    t.string   "logo_file_name"
    t.integer  "logo_file_size"
    t.string   "logo_content_type"
    t.datetime "logo_updated_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "lock_version",      :default => 0,     :null => false
  end

  create_table "publications", :force => true do |t|
    t.integer  "author_id",                            :null => false
    t.integer  "nature_id",                            :null => false
    t.text     "name",                                 :null => false
    t.string   "description"
    t.text     "field_values"
    t.text     "name_title"
    t.string   "name_source"
    t.string   "name_reference"
    t.date     "name_date"
    t.string   "origin",                               :null => false
    t.text     "url"
    t.string   "state"
    t.string   "document_file_name"
    t.integer  "document_file_size"
    t.string   "document_content_type"
    t.datetime "document_updated_at"
    t.string   "document_fingerprint"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "lock_version",          :default => 0, :null => false
  end

  add_index "publications", ["author_id"], :name => "index_publications_on_author_id"
  add_index "publications", ["name"], :name => "index_publications_on_name"
  add_index "publications", ["nature_id"], :name => "index_publications_on_nature_id"
  add_index "publications", ["origin"], :name => "index_publications_on_origin"
  add_index "publications", ["state"], :name => "index_publications_on_state"

  create_table "tags", :force => true do |t|
    t.integer  "label_id",                    :null => false
    t.integer  "tagged_id",                   :null => false
    t.string   "tagged_type",                 :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "tags", ["label_id"], :name => "index_tags_on_label_id"
  add_index "tags", ["tagged_id", "tagged_type"], :name => "index_tags_on_tagged_id_and_tagged_type"

  create_table "templates", :force => true do |t|
    t.integer  "author_id",                   :null => false
    t.string   "name",                        :null => false
    t.string   "state"
    t.text     "content"
    t.integer  "uses_count",   :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "lock_version", :default => 0, :null => false
  end

  add_index "templates", ["author_id"], :name => "index_templates_on_author_id"
  add_index "templates", ["state"], :name => "index_templates_on_state"

  create_table "users", :force => true do |t|
    t.string   "first_name",                                :null => false
    t.string   "last_name",                                 :null => false
    t.boolean  "administrator",          :default => false, :null => false
    t.string   "post"
    t.string   "address"
    t.string   "phone"
    t.string   "public_email"
    t.text     "skills"
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "lock_version",           :default => 0,     :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
