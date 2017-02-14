class AddGoalAmountToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :goal_amount, :decimal, precision: 8, scale: 2
  end
end
