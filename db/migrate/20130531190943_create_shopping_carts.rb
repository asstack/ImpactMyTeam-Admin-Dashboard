class CreateShoppingCarts < ActiveRecord::Migration
  def change
    create_table :shopping_carts do |t|
      t.references :campaign
      t.decimal :subtotal, null: false, default: 0.00, precision: 8, scale: 2
      t.decimal :fees, null: false, default: 0.00, precision: 8, scale: 2
      t.decimal :taxes, null: false, default: 0.00, precision: 8, scale: 2
      t.text :notes

      t.timestamps
    end
    add_index :shopping_carts, :campaign_id
  end
end
