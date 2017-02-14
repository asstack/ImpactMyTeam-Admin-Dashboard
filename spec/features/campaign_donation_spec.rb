require 'spec_helper'

# NOTE: 5xxx.xx is used in testing to throw banking or ecommerce errors:
# https://firstdata.zendesk.com/entries/407657-How-to-generate-unsuccessful-transactions-during-testing-
# https://firstdata.zendesk.com/entries/23872458-How-to-test-AVS-Response-Codes-in-Demo
# https://firstdata.zendesk.com/entries/407654-how-do-i-setup-an-avs-filter-in-first-data-global-gateway-e4sm-real-time-payment-manager-rpm

feature 'Donating to a campaign', :vcr do
  given!(:school) { Fabricate(:school) }
  given(:creator) { Fabricate(:user) }
  given!(:campaign) { Fabricate(:campaign, school: school, creator: creator, status: 'active', goal_amount: 8000.00) }

  before { ActionMailer::Base.deliveries = [] }

  context 'a guest' do
    [5, 10, 25, 50, 100].each do |amount|
      scenario "donates $#{amount} using the quick donation button" do
        visit campaign_path(campaign)

        within '#donation' do
          click_link "$#{amount}"
        end

        input_valid_credit_card_info
        fill_in 'donation_email', with: "test_#{amount}@meetmaestro.com"
        accept_donation_terms

        click_button 'Make Donation'

        expect(page).to have_content(/successfully submitted/i)

        ActionMailer::Base.deliveries.last.to.should == ["test_#{amount}@meetmaestro.com"]
      end
    end

    scenario 'donates using the custom fuel button' do
      visit campaign_path(campaign)

      donate_custom(5001.00) # fail

      expect(page).to have_field('donation_amount_authorized', with: '5001.00')
    end

    describe 'donates using the buyout button' do
      background do
        Fabricate(:donation, campaign: campaign, status: 'collected', amount_captured: 24.75)

        visit campaign_path(campaign)
        within '#donation' do
          click_link 'Buy Out $7,975.25'
        end

        expect(page).to have_field('donation_amount_authorized', with: '7975.25')

        input_valid_credit_card_info
        accept_donation_terms

        click_button 'Make Donation'
      end

      scenario 'is successful' do
        expect(page).to have_content 'successfully submitted'
      end

      scenario 'marks the campaign as closed' do
        expect(page).to have_content 'closed'
      end

      scenario 'does not have donation buttons' do
        expect(page).to_not have_css('.donate-amount')
      end
    end

    scenario 'donates with failed authorization' do
      visit campaign_path(campaign)

      donate_custom(5001.00) #fail

      input_valid_credit_card_info
      fill_in 'donation_email', with: "test_5001.00@meetmaestro.com"
      accept_donation_terms

      click_button 'Make Donation'

      expect(page).to have_content(/not approved/i)
      ActionMailer::Base.deliveries.last.to.should == ["test_5001.00@meetmaestro.com"]

      # but I should be able to try to make a new donation from where I am
      fill_in 'donation_amount_authorized', with: '4999.99'
      fill_in 'donation_email', with: "test_4999.99@meetmaestro.com"
      accept_donation_terms

      click_button 'Make Donation'

      expect(page).to have_content(/successfully submitted/i)
      ActionMailer::Base.deliveries.last.to.should == ["test_4999.99@meetmaestro.com"]
    end

    scenario 'cannot donate more than the remaining goal amount' do
      visit new_campaign_donation_path(campaign)

      input_valid_credit_card_info

      fill_in 'donation_amount_authorized', with: '9000.00'

      accept_donation_terms

      click_button 'Make Donation'

      expect(page).to have_content(/Donation Failed/i)
      expect(page).to have_field('donation_amount_authorized', with: '8000.00')
      ActionMailer::Base.deliveries.should be_empty
    end
  end
end

private

def donate_custom(amount)
  within '#donation form.formlet' do
    fill_in 'donation_amount_authorized', with: amount.to_s
    click_button 'Fuel'
  end
end

def input_valid_credit_card_info
  fill_in 'donation_first_name', with: Faker::Name.first_name
  fill_in 'donation_last_name', with: Faker::Name.last_name
  fill_in 'donation_card_number', with: '4242424242424242'
  select 'Visa', from: 'donation_card_brand'
  select_date Date.today + 3.years, from: 'donation_card_expires_on', cc: true
  fill_in 'donation_card_verification', with: '123'

  fill_in 'donation_email', with: Faker::Internet.email
  fill_in 'donation_phone', with: Faker::PhoneNumber.phone_number
  fill_in 'donation_billing_address1', with: Faker::Address.street_address
  fill_in 'donation_billing_city', with: Faker::Address.city
  fill_in 'donation_billing_state', with: Faker::Address.state
  fill_in 'donation_billing_zip', with: Faker::Address.zip_code
end

def accept_donation_terms
  check 'donation_terms_of_service', visible: false
end
