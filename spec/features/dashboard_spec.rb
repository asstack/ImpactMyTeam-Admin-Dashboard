require 'spec_helper'

feature 'User Dashboard' do
  given!(:user) { login Fabricate(:user) }

  scenario 'can be accessed from the navigation menu', js: true do
    visit root_path
    click_link user.name

    current_path.should eq dashboard_path
  end

  describe 'shows campaign listings' do
    scenario 'created by the user' do
      campaigns = 3.times.map { Fabricate(:campaign, creator: user, school: Fabricate(:school)) }
      visit dashboard_path

      campaigns.each do |campaign|
        expect(page).to have_content(/#{campaign.title}/i)
      end
    end
  end
end
