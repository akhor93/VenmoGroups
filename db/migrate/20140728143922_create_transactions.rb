class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.belongs_to :group
      t.belongs_to :user
      t.decimal :amount
      t.string :note
      t.string :action
      t.string :venmo_transaction_ids
      t.timestamps
    end
  end
end
