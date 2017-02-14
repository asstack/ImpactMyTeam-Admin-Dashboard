class CampaignsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  before_filter :restrict_status_transitions, only: :update

  load_and_authorize_resource :school, only: [:index, :new]
  load_and_authorize_resource through: :school, shallow: true
  skip_authorize_resource only: :update # done within action
  skip_load_resource only: :new

  before_filter :extract_affiliation, only: :update

  decorates_assigned :campaign
  decorates_assigned :school

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @campaigns }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @campaign }
    end
  end

  def new
    @campaign = @school.campaigns.with_status(:unsaved).merge(current_user.campaigns).first

    if @campaign.nil?
      @campaign = @school.campaigns.build
      @campaign.creator = current_user
    end

    respond_to do |format|
      if @campaign.save
        @shopping_cart = @campaign.shopping_cart
        format.html
        format.json { render json: @campaign }
      else
        format.html { redirect_to @school, notice: "An error occurred: #{@campaign.errors.inspect}" }
        format.json { render json: @campaign.errors }
      end
    end
  end

  def edit
    @shopping_cart = @campaign.shopping_cart
  end

  def update
    status_event = params[:campaign][:status_event].try(:to_sym)
    if status_event
      authorize! status_event, @campaign, message: "Not authorized to #{status_event} this campaign."
    else
      authorize! :update, @campaign
      params[:campaign][:status_event] = 'mark_as_draft'
    end

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        @affiliation.save if @affiliation
        format.html { redirect_to @campaign, notice: "Campaign was successfully updated." }
        format.json { render json: @campaign }
      else
        @shopping_cart = @campaign.shopping_cart
        format.html { render action: "edit" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to @campaign.school, notice: "Campaign was successfully deleted." }
      format.json { head :no_content }
    end
  end
end

private
def restrict_status_transitions
  params[:campaign].delete(:status_event) unless params[:status_transition]
end

def extract_affiliation
  school_role = params[:campaign].delete(:school_role) unless params[:campaign].blank?
  if school_role && school_role[:name]
    @affiliation = @campaign.school.school_roles.build(name: school_role[:name], user_id: current_user.id)
  end
end
