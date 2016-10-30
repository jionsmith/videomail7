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

ActiveRecord::Schema.define(version: 20141121132052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_contact_groups_account_contacts", id: false, force: true do |t|
    t.integer "account_contact_group_id", null: false
    t.integer "account_contact_id",       null: false
  end

  create_table "accounts", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messages_count",            default: 0
    t.integer  "templates_count",           default: 0
    t.integer  "videos_count",              default: 0
    t.string   "email",                     default: "", null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "promotion_code"
    t.string   "referrer_code"
    t.integer  "bonofa_partner_account_id"
  end

  add_index "accounts", ["bonofa_partner_account_id"], name: "index_accounts_on_bonofa_partner_account_id", using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "accounts_products", force: true do |t|
    t.integer "account_id"
    t.integer "product_id"
  end

  create_table "accounts_roles", id: false, force: true do |t|
    t.integer "account_id"
    t.integer "role_id"
  end

  add_index "accounts_roles", ["account_id", "role_id"], name: "index_accounts_roles_on_account_id_and_role_id", using: :btree

  create_table "accounts_templates", force: true do |t|
    t.integer "account_id"
    t.integer "template_id"
  end

  create_table "addressbook_account_contact_addresses", force: true do |t|
    t.integer  "account_contact_id"
    t.string   "line_1"
    t.string   "line_2"
    t.string   "line_3"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressbook_account_contact_emails", force: true do |t|
    t.integer  "account_contact_id"
    t.string   "email"
    t.boolean  "preferred"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressbook_account_contact_groups", force: true do |t|
    t.string   "name"
    t.string   "account_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  create_table "addressbook_account_contact_telephones", force: true do |t|
    t.string   "number"
    t.integer  "account_contact_id"
    t.boolean  "preferred"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addressbook_account_contacts", force: true do |t|
    t.integer  "account_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "image"
    t.datetime "deleted_at"
    t.string   "usernotice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "account_id"
    t.string   "provider"
    t.integer  "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["account_id"], name: "index_authentications_on_account_id", using: :btree

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default"
  end

  create_table "categories_products", force: true do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "message_access_logs", force: true do |t|
    t.integer  "message_id"
    t.string   "email"
    t.datetime "accessed_at"
  end

  add_index "message_access_logs", ["accessed_at"], name: "index_message_access_logs_on_accessed_at", using: :btree
  add_index "message_access_logs", ["email"], name: "index_message_access_logs_on_email", using: :btree
  add_index "message_access_logs", ["message_id"], name: "index_message_access_logs_on_message_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "subject"
    t.text     "text"
    t.integer  "template_id"
    t.integer  "video_id"
    t.integer  "account_id"
    t.string   "status",       default: "draft"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "emails"
    t.integer  "playlist_id"
    t.string   "play"
    t.string   "token"
    t.datetime "send_at"
    t.integer  "email_type"
    t.datetime "deleted_at"
    t.boolean  "downloadable"
  end

  add_index "messages", ["account_id"], name: "index_messages_on_account_id", using: :btree
  add_index "messages", ["playlist_id"], name: "index_messages_on_playlist_id", using: :btree
  add_index "messages", ["send_at"], name: "index_messages_on_send_at", using: :btree
  add_index "messages", ["template_id"], name: "index_messages_on_template_id", using: :btree
  add_index "messages", ["token"], name: "index_messages_on_token", using: :btree
  add_index "messages", ["video_id"], name: "index_messages_on_video_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "account_id"
    t.string   "plan_type"
    t.integer  "status",         default: 0
    t.integer  "tax_cents"
    t.integer  "total_cents"
    t.integer  "subtotal_cents"
    t.string   "payment_method"
    t.string   "transaction_id"
    t.string   "invoice_file"
    t.string   "token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_brand"
    t.string   "last_4_digits"
    t.text     "info"
    t.date     "expired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "plan_duration"
  end

  add_index "orders", ["account_id"], name: "index_orders_on_account_id", using: :btree
  add_index "orders", ["expired_at"], name: "index_orders_on_expired_at", using: :btree
  add_index "orders", ["payment_method"], name: "index_orders_on_payment_method", using: :btree
  add_index "orders", ["plan_duration"], name: "index_orders_on_plan_duration", using: :btree
  add_index "orders", ["plan_type"], name: "index_orders_on_plan_type", using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree

  create_table "packages", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "packages_templates", force: true do |t|
    t.integer "package_id"
    t.integer "template_id"
  end

  create_table "payments", force: true do |t|
    t.integer  "product_id"
    t.integer  "account_id"
    t.boolean  "status"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "EUR", null: false
    t.integer  "total_cents",     default: 0,     null: false
    t.string   "total_currency",  default: "EUR", null: false
    t.integer  "netto_cents",     default: 0,     null: false
    t.string   "netto_currency",  default: "EUR", null: false
    t.integer  "tax_cents",       default: 0,     null: false
    t.string   "tax_currency",    default: "EUR", null: false
    t.string   "charge_id"
    t.string   "card_id"
    t.string   "invoice"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.text     "outro_text"
  end

  add_index "playlists", ["account_id"], name: "index_playlists_on_account_id", using: :btree

  create_table "playlists_videos", force: true do |t|
    t.integer "playlist_id"
    t.integer "video_id"
  end

  create_table "products", force: true do |t|
    t.integer  "price_cents",      default: 0,     null: false
    t.string   "price_currency",   default: "EUR", null: false
    t.integer  "status",           default: 1
    t.integer  "productable_id"
    t.string   "productable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "settings", force: true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_images", force: true do |t|
    t.integer  "template_id"
    t.string   "image_name"
    t.string   "image_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "template_images", ["image_name"], name: "index_template_images_on_image_name", using: :btree
  add_index "template_images", ["template_id"], name: "index_template_images_on_template_id", using: :btree

  create_table "templates", force: true do |t|
    t.integer  "account_id"
    t.integer  "video_id"
    t.string   "title"
    t.string   "content_file"
    t.string   "preview_image"
    t.string   "text_example"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "premium_template", default: false
  end

  add_index "templates", ["account_id"], name: "index_templates_on_account_id", using: :btree
  add_index "templates", ["premium_template"], name: "index_templates_on_premium_template", using: :btree
  add_index "templates", ["video_id"], name: "index_templates_on_video_id", using: :btree

  create_table "videos", force: true do |t|
    t.integer  "account_id"
    t.string   "title"
    t.string   "panda_video_id"
    t.string   "screenshot"
    t.string   "h264_url"
    t.string   "ogg_url"
    t.string   "height"
    t.string   "width"
    t.boolean  "encoded",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stream_name"
    t.string   "file_size"
    t.float    "duration"
  end

  add_index "videos", ["account_id"], name: "index_videos_on_account_id", using: :btree

end
