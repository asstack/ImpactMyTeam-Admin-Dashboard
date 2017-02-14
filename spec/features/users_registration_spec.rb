require 'spec_helper'

describe "Registering a user" do
  before do
    visit new_user_registration_path
  end

  context 'with valid info' do
    before do
      register_user first_name: 'TB', last_name: 'Player'
    end

    it 'logs them in' do
      expect(page).to have_link('TB Player')
    end

    it 'successfully creates the user' do
      expect(page).to have_content('successfully')
    end
  end

  %w(first_name last_name email).each do |field|
    context "with invalid #{field.humanize}" do
      before do
        register_user field.to_sym => ''
      end

      it "shows an error on #{field.humanize}" do
        expect(page).to have_content("can't be blank")
      end

      it 'does no log them in' do
        expect(page).to_not have_content('Logout')
      end
    end
  end
end

feature 'Signing in' do
  given!(:user) { Fabricate(:user, email: 'josh@meetmaestro.com', password: 'password', password_confirmation: 'password') }
  given(:campaign) { Fabricate(:campaign, title: 'My Campaign', school: Fabricate(:school), creator: Fabricate(:user), status: 'active') }

  scenario 'from a non-home page', js: true do
    visit campaign_path(campaign)

    login_with_credentials 'josh@meetmaestro.com', 'password', via: 'header'

    expect(page).to have_content 'successfully'
    current_path.should == campaign_path(campaign)
    expect(page).to have_content(/My Campaign/i)
  end
end
