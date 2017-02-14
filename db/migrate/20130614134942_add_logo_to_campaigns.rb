class AddLogoToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :logo_image, :string
  end
end
