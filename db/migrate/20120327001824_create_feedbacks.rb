class CreateFeedbacks < ActiveRecord::Migration
  def change
    # Did a force because there is a error 
    create_table :feedbacks, :force => true do |t|
      t.text :note
      t.integer :domain_id
      t.timestamps
    end
  end
end
