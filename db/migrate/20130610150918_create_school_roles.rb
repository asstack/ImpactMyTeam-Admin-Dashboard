class CreateSchoolRoles < ActiveRecord::Migration
  def change
    create_table :school_roles do |t|
      t.references :user
      t.references :school
      t.string :name
      t.datetime :verified_at
      t.references :verified_by

      t.timestamps
    end
    add_index :school_roles, :user_id
    add_index :school_roles, :school_id
    add_index :school_roles, :verified_by_id
  end
end
