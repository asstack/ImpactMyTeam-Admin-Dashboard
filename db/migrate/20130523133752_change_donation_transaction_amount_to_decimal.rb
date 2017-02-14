class ChangeDonationTransactionAmountToDecimal < ActiveRecord::Migration
  def up
    change_column :donation_transactions, :amount, :decimal, precision: 8, scale: 2
  end

  def down
    raise raise ActiveRecord::IrreversibleMigration
  end
end
