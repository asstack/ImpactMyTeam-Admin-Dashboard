require 'spec_helper'

feature 'Searching for a school' do
  given!(:my_school) { Fabricate(:school, name: 'My School', city: 'Grand Rapids', region: 'Michigan') }
  given!(:other_school) { Fabricate(:school, name: 'Batman University', city: 'Gotham City', region: 'Illinois') }

  background { visit schools_path }

  scenario 'prompts the user to begin searching' do
    expect(page).to have_content 'Begin typing to find your school'
  end

  scenario 'begins showing results after typing', js: true do
    within '#main' do
      fill_in 'query', with: 'my scho'

      find('#school-list').should have_content(/My School/i)
    end
  end

  context 'with a campaign' do
    given!(:campaign) { Fabricate(:campaign, school: my_school, goal_amount: 2500.00, status: 'active') }
    before do
      Fabricate(:donation, campaign: campaign, status: 'collected', amount_captured: 1850.00)
      visit schools_path(query: 'My School')
    end

    subject { page.find("#active_campaign_#{campaign.id}") }
    it { should have_content(/74% Funded/i) }
    it { should have_content(/\$2,500 Goal/i) }
  end

  context 'with empty results' do
    scenario 'prompts user to add their school' do
      visit schools_path(query: 'Gotham City High')
      expect(page).to have_content(/No results found/i)
      expect(page).to have_link('Add my School')
    end
  end
end
