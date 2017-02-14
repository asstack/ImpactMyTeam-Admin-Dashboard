class AddDefaultValueForCampaignGoalAmount < ActiveRecord::Migration
  def up
    change_column :campaigns, :goal_amount, :decimal, null: false, precision: 8, scale: 2, default: 0.00
  end

  def down
  end
end
