class CreateMassDomains < ActiveRecord::Migration
  def change
    create_table :mass_domains do |t|
      t.text :domains
      t.integer :parse_type, :default => 1
      t.boolean :added, :default => false
      t.timestamp :added_on
      t.boolean :error, :default => false
      t.text :error_message
      t.timestamps
    end
  end
end
