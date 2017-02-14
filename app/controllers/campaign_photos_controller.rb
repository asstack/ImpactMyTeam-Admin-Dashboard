class CampaignPhotosController < ApplicationController
  # Filters!
  before_filter :load_campaign, only: [:create]

  # POST create
  def create
    authorize! :update, @campaign
    @photo = @campaign.campaign_photos.build params[:campaign_photo]
    respond_to do |format|
      if @photo.save
        format.js
      else
        format.js
      end
    end
  end

  # DELETE destroy
  def destroy
    @photo = CampaignPhoto.find params[:id]
      respond_to do |format|
      if @photo.destroy
        format.js
      else
        format.js
      end
    end
  end

  private
  def load_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
