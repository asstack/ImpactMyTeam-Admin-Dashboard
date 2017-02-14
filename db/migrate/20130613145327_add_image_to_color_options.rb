class AddImageToColorOptions < ActiveRecord::Migration
  def change
    add_column :color_options, :image, :string
  end
end
