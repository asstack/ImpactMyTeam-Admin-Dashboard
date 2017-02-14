class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :title
      t.date :end_date
      t.text :summary
      t.string :twitter_username
      t.string :facebook_url
      t.references :school
      t.references :school_team
      t.references :creator

      t.timestamps
    end
    add_index :campaigns, :school_id
    add_index :campaigns, :school_team_id
    add_index :campaigns, :creator_id
  end
end
