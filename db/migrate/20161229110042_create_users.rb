class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.datetime "created_at",                                         null: false
      t.datetime "updated_at",                                         null: false
      t.date     "date_created_at"
      t.string   "email"
      t.string   "username"
      t.string   "crypted_password"
      t.string   "password_salt"
      t.string   "persistence_token"
      t.string   "single_access_token"
      t.string   "perishable_token"
      t.integer  "login_count",                        default: 0,     null: false
      t.integer  "failed_login_count",                 default: 0,     null: false
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.boolean  "active",                             default: false
      t.boolean  "approved",                           default: false
      t.boolean  "confirmed",                          default: false
      t.boolean  "email_confirmed",                    default: false
      t.boolean  "bulk_email_confirmed",               default: false
      t.string   "time_zone"
      t.text     "details",              limit: 65535
      t.boolean  "admin",                              default: false
      t.string   "first_name"
      t.string   "last_name"
      t.string "pwpt"
      t.string "subscription_type", default: "basic"
      t.index ["email"], name: "email", unique: true, using: :btree
      t.index ["username"], name: "username", unique: true, using: :btree
    end
  end
end