class CreateCampaignPhotos < ActiveRecord::Migration
  def change
    create_table :campaign_photos do |t|
      t.string :image
      t.references :campaign

      t.timestamps
    end
    add_index :campaign_photos, :campaign_id
  end
end
