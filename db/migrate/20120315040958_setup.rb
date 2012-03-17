class Setup < ActiveRecord::Migration
  def change
    create_table "domains", :force => true do |t|
      t.text      "url"
      t.string    "title"
      t.text      "description"
      t.timestamp "data_recived_on"
      t.text      "mobile_url"
      t.text      "favicon_path",    :default => "favicon.ico"
      t.timestamp "create_at"
      t.timestamp "updated_at"
    end

    create_table "taggings", :force => true do |t|
      t.integer   "domain_id"
      t.integer   "tag_id"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "tags", :force => true do |t|
      t.string    "name"
      t.timestamp "created_at"
      t.timestamp "updated_at"
    end

    create_table "users", :force => true do |t|
      t.string    "first_name",                             :null => false
      t.string    "last_name",                              :null => false
      t.string    "email",                                  :null => false
      t.string    "crypted_password",                       :null => false
      t.string    "password_salt",                          :null => false
      t.string    "persistence_token",                      :null => false
      t.string    "single_access_token",                    :null => false
      t.string    "perishable_token",                       :null => false
      t.integer   "login_count",         :default => 0,     :null => false
      t.integer   "failed_login_count",  :default => 0,     :null => false
      t.timestamp "last_request_at"
      t.timestamp "current_login_at"
      t.timestamp "last_login_at"
      t.string    "current_login_ip"
      t.string    "last_login_ip"
      t.integer   "access_level",        :default => 0
      t.boolean   "active",              :default => false
    end

  end
end
