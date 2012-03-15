class AddTimeStamps < ActiveRecord::Migration
  def change
    add_column :domains, :create_at, :datetime
    add_column :domains, :updated_at, :datetime
  end
end
