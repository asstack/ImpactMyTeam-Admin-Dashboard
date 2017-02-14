class AddStatusToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :status, :string
    add_index :donations, :status
  end
end
