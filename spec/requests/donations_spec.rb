require 'spec_helper'

describe "Donations" do
  describe "New /campaigns/:campaign_id/donations/new" do
    it "responds successfully" do
      get new_campaign_donation_path(Fabricate(:campaign, status: 'active'))
      response.status.should be(200)
    end
  end
end
