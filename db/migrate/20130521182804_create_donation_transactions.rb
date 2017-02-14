class CreateDonationTransactions < ActiveRecord::Migration
  def change
    create_table :donation_transactions do |t|
      t.references :donation
      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params

      t.timestamps
    end
    add_index :donation_transactions, :donation_id
  end
end
