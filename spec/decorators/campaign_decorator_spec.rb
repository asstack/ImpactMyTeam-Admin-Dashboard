require 'spec_helper'

describe CampaignDecorator do
  let(:campaign) { Fabricate(:campaign, status: 'active', goal_amount: goal_amount) }
  let(:goal_amount) { 100.00 }

  describe '#donation_progress_message' do
    it 'properly formats the string for zero donations' do
      campaign.collected_donations.stub(size: 0)
      campaign.collected_donations.stub(total: 0)
      result = CampaignDecorator.new(campaign).donation_progress_message # .should == '0 people have funded $0 of the $100 goal.'

      markup = Capybara.string(result)
      markup.should have_content '0 people have funded $0 of the $100 goal.'
    end

    it 'properly formats the string for 1 donation' do
      campaign.collected_donations.stub(size: 1)
      campaign.collected_donations.stub(total: 20.25)
      result = CampaignDecorator.new(campaign).donation_progress_message # .should == '1 person has funded $20.25 of the $100 goal.'

      markup = Capybara.string(result)
      markup.should have_content '1 person has funded $20.25 of the $100 goal.'
    end

    it 'properly formats the string for more than 1 donation' do
      campaign.collected_donations.stub(size: 2)
      campaign.collected_donations.stub(total: 20.00)
      result = CampaignDecorator.new(campaign).donation_progress_message # .should == '2 people have funded $20 of the $100 goal.'

      markup = Capybara.string(result)
      markup.should have_content '2 people have funded $20 of the $100 goal.'
    end
  end

  describe '#goal_amount_usd' do
    it 'is formatted as USD' do
      campaign.goal_amount = 100.25
      CampaignDecorator.new(campaign).goal_amount_usd.should == '$100.25'
    end
    it 'rounds to dollar if it is $*.00' do
      campaign.goal_amount = 100.00
      CampaignDecorator.new(campaign).goal_amount_usd.should == '$100'
    end
  end

 describe '#goal_remaining_usd' do
    it 'is formatted in USD' do
      campaign.goal_amount = 100.25
      CampaignDecorator.new(campaign).goal_remaining_usd.should == '$100.25'
    end

    it 'rounds to dollar if it is $*.00' do
      campaign.goal_amount = 100.00
      CampaignDecorator.new(campaign).goal_amount_usd.should == '$100'
    end
  end

  describe '#total_collected_amount_usd' do
    it 'is formatted as USD' do
      campaign.collected_donations.stub(total: 20.75)
      CampaignDecorator.new(campaign).total_collected_amount_usd.should == '$20.75'
    end

    it 'it rounds to dollar if it is $*.00' do
      campaign.collected_donations.stub(total: 20.00)
      CampaignDecorator.new(campaign).total_collected_amount_usd.should == '$20'
    end
  end

  describe '#facebook_url' do
    it 'is a link to the facebook url' do
      url = 'http://www.facebook.com/some_link'
      campaign = Campaign.new(facebook_url: url)
      result = CampaignDecorator.new(campaign).facebook_url
      markup = Capybara.string(result)
      markup.should have_css("a[href='#{url}']", text: "#{url}")
    end
  end

  describe '#twitter_username' do
    it 'is a link to their twitter profile' do
      twit = 'horse_ebooks'
      campaign = Campaign.new(twitter_username: twit)
      result = CampaignDecorator.new(campaign).twitter_username
      markup = Capybara.string(result)
      markup.should have_css("a[href='http://www.twitter.com/#{twit}']", text: twit)
    end
  end
end
