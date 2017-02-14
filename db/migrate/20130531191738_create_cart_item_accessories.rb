class CreateCartItemAccessories < ActiveRecord::Migration
  def change
    create_table :cart_item_accessories do |t|
      t.references :cart_item
      t.references :accessory

      t.timestamps
    end
    add_index :cart_item_accessories, :cart_item_id
    add_index :cart_item_accessories, :accessory_id
  end
end
