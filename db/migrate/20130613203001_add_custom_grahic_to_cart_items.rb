class AddCustomGrahicToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :custom_graphic, :string
  end
end
