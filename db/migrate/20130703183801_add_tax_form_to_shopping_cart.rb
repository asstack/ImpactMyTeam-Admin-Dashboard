class AddTaxFormToShoppingCart < ActiveRecord::Migration
  def change
    add_column :shopping_carts, :tax_document, :string
  end
end
