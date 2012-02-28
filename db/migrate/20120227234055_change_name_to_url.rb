class ChangeNameToUrl < ActiveRecord::Migration
  def change
    rename_column :domains, :name, :url
  end
end
