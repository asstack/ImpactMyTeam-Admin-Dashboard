class CreateSchoolContacts < ActiveRecord::Migration
  def change
    create_table :school_contacts do |t|
      t.references :school
      t.string :contact_type
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email

      t.timestamps
    end
    add_index :school_contacts, :school_id
  end
end
