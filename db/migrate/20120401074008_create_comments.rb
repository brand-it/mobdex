class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :note
      t.integer :feedback_id
      t.integer :created_by, :default => nil
      t.timestamps
    end
    
    add_column :feedbacks, :created_by, :interger, :default => nil
  end
end
