class ChangeCampaignStateToStatus < ActiveRecord::Migration
  def change
    rename_column :campaigns, :state, :status
  end
end
