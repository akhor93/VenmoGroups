class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :venmo_id
      t.timestamps
    end
  end
end
