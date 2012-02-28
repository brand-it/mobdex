class AddMobileUrl < ActiveRecord::Migration
  def change
    add_column :domains, :mobile_url, :string
  end
end
