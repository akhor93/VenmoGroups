class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :venmo_id
      t.integer :expires_in
      t.datetime :updated_at, :default => Time.now
      t.timestamps
    end
  end
end
