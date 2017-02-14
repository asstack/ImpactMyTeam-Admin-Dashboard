class AddDonationAmountsToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :amount_authorized, :decimal, precision: 8, scale: 2
    add_column :donations, :amount_captured, :decimal, precision: 8, scale: 2
  end
end
