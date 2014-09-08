class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.text :members
      t.float :amount
      t.text :note
      t.string :action
      t.text :venmo_transaction_ids
      t.timestamps
    end
  end
end
