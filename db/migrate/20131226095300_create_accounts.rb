class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :user_id
      t.integer :fav_counter, :default => 0
      t.boolean :is_listed, :default => false
      t.boolean :is_following, :default => false
      t.string  :keyword
      t.string  :subscribed_id
      t.string :status
      t.timestamps null: false
    end
  end
end
