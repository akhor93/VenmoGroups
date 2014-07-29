class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :access_token
      t.string :refresh_token
      t.string :picture_url
      t.string :venmo_id
      t.timestamps
    end
  end
end
