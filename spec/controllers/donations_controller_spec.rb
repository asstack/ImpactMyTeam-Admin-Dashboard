require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe DonationsController do
  let!(:campaign) { Fabricate(:campaign, status: 'active', school: Fabricate(:school), creator: Fabricate(:user)) }
  let(:valid_attributes) { Fabricate.attributes_for(:donation).tap{|o| o.delete(:campaign)} }

  describe "GET new" do
    it "assigns a new donation as @donation" do
      get :new, {campaign_id: campaign.id}
      assigns(:donation).should be_a_new(Donation)
    end
  end

  describe "POST create", :vcr do
    describe "with valid params" do
      it "creates a new Donation" do
        expect {
          post :create, {campaign_id: campaign.id, donation: valid_attributes}
        }.to change(Donation, :count).by(1)
      end

      it "assigns a newly created donation as @donation" do
        post :create, {campaign_id: campaign.id, donation: valid_attributes}
        assigns(:donation).should be_a(Donation)
        assigns(:donation).should be_persisted
      end

      it "redirects to the created donation" do
        post :create, {campaign_id: campaign.id, donation: valid_attributes}
        response.should redirect_to(campaign)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved donation as @donation" do
        # Trigger the behavior that occurs when invalid params are submitted
        Donation.any_instance.stub(:save).and_return(false)
        post :create, {campaign_id: campaign.id, donation: { "first_name" => "invalid value" }}
        assigns(:donation).should be_a_new(Donation)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Donation.any_instance.stub(:save).and_return(false)
        post :create, {campaign_id: campaign.id, donation: { "first_name" => "invalid value" }}
        response.should render_template("new")
      end
    end
  end
end
