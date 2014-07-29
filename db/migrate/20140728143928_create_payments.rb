class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :charge

      t.timestamps
    end
  end
end
