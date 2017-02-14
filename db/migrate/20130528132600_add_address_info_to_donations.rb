class AddAddressInfoToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :email, :string
    add_column :donations, :phone, :string
    add_column :donations, :billing_address1, :string
    add_column :donations, :billing_address2, :string
    add_column :donations, :billing_city, :string
    add_column :donations, :billing_state, :string
    add_column :donations, :billing_zip, :string
    add_column :donations, :billing_country, :string
  end
end
