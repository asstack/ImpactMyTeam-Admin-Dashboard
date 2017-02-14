class DonationsController < ApplicationController
  before_filter :load_campaign

  def new
    @donation = @campaign.donations.build(params[:donation])

    if ActiveMerchant::Billing::Base.test?
      @donation.set_fake_info
    end
  end

  def create
    @donation = @campaign.donations.build(params[:donation])
    @donation.ip_address = request.remote_ip

    if @donation.save
      if @donation.authorize && @donation.collect_funds
        DonationMailer.successful(@donation).deliver
        @campaign.close if @campaign.goal_completed?
        redirect_to @campaign, notice: 'Donation successfully submitted. You will receive an email confirmation shortly.'
      else
        DonationMailer.unsuccessful(@donation).deliver
        failed_donation = @donation
        flash[:alert] = failed_donation.transactions.last.message
        @donation = @campaign.donations.build(params[:donation])
        render :new
      end
    else
      @donation.amount_authorized = @donation.campaign_goal_remaining
      flash[:alert] = 'Donation Failed.'
      render :new
    end
  end

  private

  def load_campaign
    @campaign = Campaign.with_status(:active).find(params[:campaign_id])
  end
end
