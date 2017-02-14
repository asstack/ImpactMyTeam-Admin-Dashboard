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

ActiveRecord::Schema.define(:version => 20130703183801) do

  create_table "accessory_options", :force => true do |t|
    t.integer  "primary_id"
    t.integer  "accessory_id"
    t.boolean  "exclusive",    :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "accessory_options", ["accessory_id"], :name => "index_accessory_options_on_accessory_id"
  add_index "accessory_options", ["primary_id"], :name => "index_accessory_options_on_primary_id"

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "athletic_conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "campaign_photos", :force => true do |t|
    t.string   "image"
    t.integer  "campaign_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "campaign_photos", ["campaign_id"], :name => "index_campaign_photos_on_campaign_id"

  create_table "campaigns", :force => true do |t|
    t.string   "title",                                          :default => ""
    t.date     "end_date"
    t.text     "summary"
    t.string   "twitter_username"
    t.string   "facebook_url"
    t.integer  "school_id"
    t.integer  "school_team_id"
    t.integer  "creator_id"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.date     "start_date"
    t.integer  "duration_in_days"
    t.string   "status"
    t.decimal  "goal_amount",      :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "logo_image"
  end

  add_index "campaigns", ["creator_id"], :name => "index_campaigns_on_creator_id"
  add_index "campaigns", ["school_id"], :name => "index_campaigns_on_school_id"
  add_index "campaigns", ["school_team_id"], :name => "index_campaigns_on_school_team_id"

  create_table "cart_item_accessories", :force => true do |t|
    t.integer  "cart_item_id"
    t.integer  "accessory_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "cart_item_accessories", ["accessory_id"], :name => "index_cart_item_accessories_on_accessory_id"
  add_index "cart_item_accessories", ["cart_item_id"], :name => "index_cart_item_accessories_on_cart_item_id"

  create_table "cart_items", :force => true do |t|
    t.integer  "shopping_cart_id"
    t.integer  "product_variant_id"
    t.integer  "product_color_id"
    t.decimal  "subtotal",             :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "quantity",                                           :default => 0,   :null => false
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "custom_product_image"
    t.string   "custom_graphic"
  end

  add_index "cart_items", ["product_color_id"], :name => "index_cart_items_on_product_color_id"
  add_index "cart_items", ["product_variant_id"], :name => "index_cart_items_on_product_variant_id"
  add_index "cart_items", ["shopping_cart_id"], :name => "index_cart_items_on_shopping_cart_id"

  create_table "color_options", :force => true do |t|
    t.integer  "product_variant_id"
    t.integer  "product_color_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image"
  end

  add_index "color_options", ["product_color_id"], :name => "index_color_options_on_product_color_id"
  add_index "color_options", ["product_variant_id"], :name => "index_color_options_on_product_variant_id"

  create_table "donation_transactions", :force => true do |t|
    t.integer  "donation_id"
    t.string   "action"
    t.decimal  "amount",        :precision => 8, :scale => 2
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "donation_transactions", ["donation_id"], :name => "index_donation_transactions_on_donation_id"

  create_table "donations", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_brand"
    t.date     "card_expires_on"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.decimal  "amount_authorized", :precision => 8, :scale => 2
    t.decimal  "amount_captured",   :precision => 8, :scale => 2
    t.string   "status"
    t.string   "email"
    t.string   "phone"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip"
    t.string   "billing_country"
  end

  add_index "donations", ["campaign_id"], :name => "index_donations_on_campaign_id"
  add_index "donations", ["status"], :name => "index_donations_on_status"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.string   "document_code"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"

  create_table "product_colors", :force => true do |t|
    t.string   "name"
    t.string   "hex"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "product_variants", :force => true do |t|
    t.integer  "product_id"
    t.string   "configuration"
    t.text     "configuration_notes"
    t.string   "item_code"
    t.decimal  "price",                :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "custom_graphic_price", :precision => 8, :scale => 2
    t.boolean  "default",                                            :default => false
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.string   "image"
  end

  add_index "product_variants", ["product_id"], :name => "index_product_variants_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.text     "description"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "show_in_catalog", :default => true
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "school_addresses", :force => true do |t|
    t.integer  "school_id"
    t.string   "line_1",       :null => false
    t.string   "line_2"
    t.string   "city",         :null => false
    t.string   "region",       :null => false
    t.string   "postal_code",  :null => false
    t.string   "country",      :null => false
    t.string   "address_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "phone_number"
  end

  add_index "school_addresses", ["school_id"], :name => "index_school_addresses_on_school_id"

  create_table "school_contacts", :force => true do |t|
    t.integer  "school_id"
    t.string   "contact_type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "school_contacts", ["school_id"], :name => "index_school_contacts_on_school_id"

  create_table "school_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "name"
    t.datetime "verified_at"
    t.integer  "verified_by_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "school_roles", ["school_id"], :name => "index_school_roles_on_school_id"
  add_index "school_roles", ["user_id"], :name => "index_school_roles_on_user_id"
  add_index "school_roles", ["verified_by_id"], :name => "index_school_roles_on_verified_by_id"

  create_table "school_teams", :force => true do |t|
    t.string   "name"
    t.string   "sport"
    t.string   "mascot"
    t.string   "colors"
    t.integer  "school_contact_id"
    t.string   "website_url"
    t.integer  "athletic_conference_id"
    t.integer  "school_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "school_teams", ["athletic_conference_id"], :name => "index_school_teams_on_athletic_conference_id"
  add_index "school_teams", ["school_contact_id"], :name => "index_school_teams_on_school_contact_id"
  add_index "school_teams", ["school_id"], :name => "index_school_teams_on_school_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "school_type"
    t.string   "school_level"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "website_url"
    t.string   "athletics_url"
    t.string   "city"
    t.string   "region"
  end

  add_index "schools", ["city"], :name => "index_schools_on_city"
  add_index "schools", ["name"], :name => "index_schools_on_name"
  add_index "schools", ["region"], :name => "index_schools_on_region"

  create_table "shopping_carts", :force => true do |t|
    t.integer  "campaign_id"
    t.decimal  "subtotal",     :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "fees",         :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "taxes",        :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.text     "notes"
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
    t.decimal  "shipping",     :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "tax_document"
  end

  add_index "shopping_carts", ["campaign_id"], :name => "index_shopping_carts_on_campaign_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
