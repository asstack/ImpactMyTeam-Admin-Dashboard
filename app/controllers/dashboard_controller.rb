class DashboardController < ApplicationController
  before_filter :authenticate_user!

  decorates_assigned :user_campaigns
  decorates_assigned :other_campaigns

  def index
    @user_campaigns = current_user.campaigns.order('status ASC, updated_at DESC')
    @user_campaigns = @user_campaigns.with_status(params[:status]) if params[:status]

    # this is super complicated, but basically:
    #   1. Anything I can access
    #   2. that wasn't created by me
    #   3. that belongs to a school I can admin
    @other_campaigns = Campaign.accessible_by(current_ability).not_created_by(current_user).joins(:school).merge(current_user.schools.managed.verified)
    @other_campaigns = @other_campaigns.with_status(params[:status]) if params[:status]
  end
end
