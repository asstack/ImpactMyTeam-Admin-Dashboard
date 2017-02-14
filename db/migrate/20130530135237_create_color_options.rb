class CreateColorOptions < ActiveRecord::Migration
  def change
    create_table :color_options do |t|
      t.references :product_variant
      t.references :product_color

      t.timestamps
    end
    add_index :color_options, :product_variant_id
    add_index :color_options, :product_color_id
  end
end
