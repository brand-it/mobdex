class AddedStatusCode < ActiveRecord::Migration
  def change
    add_column :domains, :code, :integer
  end
end
