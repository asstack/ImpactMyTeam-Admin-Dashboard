class AddCustomProductImageToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :custom_product_image, :string
  end
end
