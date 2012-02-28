class RemoteDomains < ActiveRecord::Migration
  def change
    remove_column :domains, :sub_name
    remove_column :domains, :top_level
    add_column :domains, :title, :string
    add_column :domains, :description, :text
  end
end
