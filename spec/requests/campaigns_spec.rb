require 'spec_helper'

describe "Campaigns" do
  let(:school) { Fabricate(:school) }
  let(:campaign) { Fabricate(:campaign, school: school, creator: Fabricate(:user), status: 'active') }
  describe "GET /campaigns" do
    describe '#index' do
      before { get school_campaigns_path(school) }
      specify { response.status.should be 200 }
    end

    describe '#show' do
      before { get campaign_path(campaign) }
      specify { response.status.should be 200 }
    end

    describe '#edit' do
      before { get edit_campaign_path(campaign) }
      specify { response.should redirect_to new_user_session_path }
    end

    describe '#new' do
      before { get new_school_campaign_path(school) }
      specify { response.should redirect_to new_user_session_path }
    end
  end
end
