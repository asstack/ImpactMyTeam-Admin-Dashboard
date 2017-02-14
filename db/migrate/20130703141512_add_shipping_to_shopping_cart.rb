class AddShippingToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts, :shipping, :decimal, null: false, default: 0.00, precision: 8, scale: 2
  end
end
