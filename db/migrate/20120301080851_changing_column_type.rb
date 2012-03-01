class ChangingColumnType < ActiveRecord::Migration
  def change
    change_column :domains, :url, :text
    change_column :domains, :mobile_url, :text
  end
end
