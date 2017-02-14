class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :shopping_cart
      t.references :product_variant
      t.references :product_color
      t.decimal :subtotal, null: false, default: 0.00, precision: 8, scale: 2
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
    add_index :cart_items, :shopping_cart_id
    add_index :cart_items, :product_variant_id
    add_index :cart_items, :product_color_id
  end
end
