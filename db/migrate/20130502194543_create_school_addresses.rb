class CreateSchoolAddresses < ActiveRecord::Migration
  def change
    create_table :school_addresses do |t|
      t.references :school
      t.string :line_1, null: false
      t.string :line_2
      t.string :city, null: false
      t.string :region, null: false
      t.string :postal_code, null: false
      t.string :country, null: false
      t.string :address_type

      t.timestamps
    end
    add_index :school_addresses, :school_id
  end
end
