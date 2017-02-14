class SetCampaignTitleDefaultValue < ActiveRecord::Migration
  def up
    change_column :campaigns, :title, :string, default: ''
  end

  def down
  end
end
