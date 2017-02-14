class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.references :campaign
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_brand
      t.date :card_expires_on

      t.timestamps
    end
    add_index :donations, :campaign_id
  end
end
