class CreateProductVariants < ActiveRecord::Migration
  def change
    create_table :product_variants do |t|
      t.references :product
      t.string :configuration
      t.text :configuration_notes
      t.string :item_code
      t.decimal :price, null: false, default: 0.00, precision: 8, scale: 2
      t.decimal :custom_graphic_price, precision: 8, scale: 2
      t.boolean :default, default: false

      t.timestamps
    end
    add_index :product_variants, :product_id
  end
end
