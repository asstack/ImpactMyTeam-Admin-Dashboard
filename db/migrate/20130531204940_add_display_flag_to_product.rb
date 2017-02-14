class AddDisplayFlagToProduct < ActiveRecord::Migration
  def change
    add_column :products, :show_in_catalog, :boolean, default: true
  end
end
