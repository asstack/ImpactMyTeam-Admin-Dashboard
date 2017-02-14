require "spec_helper"

describe DonationMailer do
  let(:donation) { Fabricate(:donation, campaign: campaign, email: 'test@meetmaestro.com', amount_authorized: amount).tap(&:authorize) }
  let(:campaign) { Fabricate(:campaign, school: school, title: 'My Campaign', status: 'active', goal_amount: 10000.00) }
  let(:school) { Fabricate(:school, name: 'My School') }

  describe "unsuccessful", :vcr do
    let(:amount) { 5001.01 }
    subject(:mail) { DonationMailer.unsuccessful(donation) }

    describe "rendering the headers" do
      its(:subject) { should eq("Unsuccessful donation to #{campaign.title} [Impact My Team]") }
      its(:to) { should eq(["test@meetmaestro.com"]) }
      its(:from) { should eq(["noreply@impactmyteam.com"]) }
    end

    describe "rendering the body" do
      specify { mail.body.encoded.should match(campaign.title) }
      specify { mail.body.encoded.should match(school.name) }
      specify { mail.body.encoded.should match("was declined") }
    end
  end

  describe "successful", :vcr do
    let(:amount) { 100.00 }
    subject(:mail) { DonationMailer.successful(donation) }

    describe "rendering the headers" do
      its(:subject) { should eq("Successful donation to #{campaign.title} [Impact My Team]") }
      its(:to) { should eq(["test@meetmaestro.com"]) }
      its(:from) { should eq(["noreply@impactmyteam.com"]) }
    end

    describe "rendering the body" do
      specify { mail.body.encoded.should match("Thank you") }
      specify { mail.body.encoded.should match(campaign.title) }
      specify { mail.body.encoded.should match(school.name) }
      specify { mail.body.encoded.should match("was successful") }
    end
  end

end
