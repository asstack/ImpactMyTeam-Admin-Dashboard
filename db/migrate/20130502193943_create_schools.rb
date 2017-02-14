class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :school_type
      t.string :school_level

      t.timestamps
    end
  end
end
