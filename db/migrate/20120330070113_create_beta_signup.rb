class CreateBetaSignup < ActiveRecord::Migration
  def change
    create_table :beta_signups do |t|
      t.string :email
      t.boolean :excepted, :default => false
      t.timestamps
    end
  end
end
