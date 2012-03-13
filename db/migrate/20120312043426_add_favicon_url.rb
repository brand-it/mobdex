class AddFaviconUrl < ActiveRecord::Migration
  def change
    add_column :domains, :favicon_path, :text, :default => "favicon.ico"
  end
end
