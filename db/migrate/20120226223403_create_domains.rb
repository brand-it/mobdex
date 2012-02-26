class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.string :sub_name, :default => "www"
      t.string :top_level, :default => "com"
    end
  end
end
