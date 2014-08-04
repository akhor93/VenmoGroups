class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :group
      t.string :venmo_transaction_id
      t.timestamps
    end
  end
end
