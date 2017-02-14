class AddImageToProductVariant < ActiveRecord::Migration
  def change
    add_column :product_variants, :image, :string
  end
end
