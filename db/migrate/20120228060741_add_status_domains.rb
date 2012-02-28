class AddStatusDomains < ActiveRecord::Migration
  def change
    add_column :domains, :data_recived_on, :timestamp
  end
end
