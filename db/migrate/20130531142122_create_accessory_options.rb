class CreateAccessoryOptions < ActiveRecord::Migration
  def change
    create_table :accessory_options do |t|
      t.references :primary
      t.references :accessory
      t.boolean :exclusive, default: false

      t.timestamps
    end
    add_index :accessory_options, :primary_id
    add_index :accessory_options, :accessory_id
  end
end
