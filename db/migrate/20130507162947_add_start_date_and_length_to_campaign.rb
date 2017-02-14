class AddStartDateAndLengthToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :start_date, :date
    add_column :campaigns, :duration_in_days, :integer
  end
end
