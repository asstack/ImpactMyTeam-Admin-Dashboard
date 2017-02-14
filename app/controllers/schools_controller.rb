class SchoolsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  decorates_assigned :school
  decorates_assigned :schools, with: SchoolDecorator
  decorates_assigned :campaigns, with: CampaignDecorator

  def index
    @schools = School.search_by_full_name(schools_query).page(params[:page])

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @schools }
    end
  end

  def show
    @school = School.find(params[:id])
    @campaigns = @school.campaigns.accessible_by(current_ability).order('status ASC, updated_at DESC')

    respond_to do |format|
      format.html
      format.json { render json: @school }
    end
  end

  def new
    authorize! :create, School

    @school = School.new
    @default_address = @school.addresses.default.first_or_initialize
    @primary_contact = @school.contacts.first_or_initialize
    @school_role = current_user.school_roles.for_school(@school).first_or_initialize
  end

  def create
    authorize! :create, School
    role_params = params[:school].delete(:school_roles)
    role_params.merge!(user_id: current_user.id) if role_params
    @school = School.new(params[:school])

    if @school.save && @school.school_roles.create(role_params)
      redirect_to school_path(@school), notice: 'School was successfully created.'
    else
      render 'new'
    end
  end

  def edit
    @school = School.find(params[:id])
    authorize! :update, @school

    @default_address = @school.addresses.default.first_or_initialize
    @primary_contact = @school.contacts.first_or_initialize
  end

  def update
    @school = School.find(params[:id])

    authorize! :update, @school

    if @school.update_attributes(params[:school])
      redirect_to school_path(@school), notice: 'School was successfully updated.'
    else
      render 'edit'
    end
  end
end
