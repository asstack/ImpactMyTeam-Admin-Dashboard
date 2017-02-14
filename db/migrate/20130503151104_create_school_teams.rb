class CreateSchoolTeams < ActiveRecord::Migration
  def change
    create_table :school_teams do |t|
      t.string :name
      t.string :sport
      t.string :mascot
      t.string :colors
      t.references :school_contact
      t.string :website_url
      t.references :athletic_conference
      t.references :school

      t.timestamps
    end
    add_index :school_teams, :school_contact_id
    add_index :school_teams, :athletic_conference_id
    add_index :school_teams, :school_id
  end
end
