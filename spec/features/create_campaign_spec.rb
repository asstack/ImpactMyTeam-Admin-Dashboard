require 'spec_helper'

feature 'Create a campaign' do
  given!(:my_school) { Fabricate(:school, name: 'My School', city: 'Grand Rapids', region: 'Michigan') }
  given!(:other_school) { Fabricate(:school, name: 'Batman University', city: 'Gotham City', region: 'Illinois') }

  context 'from search results', js: true do
    context 'as a user' do
      context 'who is already logged in' do
        given!(:user) { login Fabricate(:user) }

        scenario 'I can make a new campaign for my school' do
          navigate_to_new_campaign_for 'my school'

          expect(page).to have_content(/New Campaign for My School/i)

          fill_in_campaign_form
          click_link 'Save and Preview'

          expect(page).to have_content 'successfully updated'

          accept_the_terms
          click_button 'Submit for Approval'

          expect(page).to have_content 'successfully updated'
        end
      end

      context 'who is not yet logged in' do
        given!(:user) { Fabricate(:user, email: 'josh@meetmaestro.com', password: 'password', password_confirmation: 'password') }

        scenario 'I can make a new campaign for my school after logging in' do
          navigate_to_new_campaign_for 'my school'
          login_with_credentials 'josh@meetmaestro.com', 'password'

          expect(page).to have_content(/New Campaign for My School/i)

          fill_in_campaign_form

          click_link 'Save and Preview'

          expect(page).to have_content 'successfully updated'

          accept_the_terms
          click_button 'Submit for Approval'

          expect(page).to have_content 'successfully updated'

          expect(page).to have_content(/Awaiting Approval/i)

          Campaign.last.should be_awaiting_approval
        end
      end
    end
  end
end

feature 'Campaign availability' do
  given!(:school) { Fabricate(:school, name: 'My School', city: 'Grand Rapids', region: 'Michigan') }
  given(:creator) { Fabricate(:user) }
  given!(:draft_campaign) { Fabricate(:campaign, title: 'My Draft Campaign', school: school, creator: creator) }
  given!(:active_campaign) { Fabricate(:campaign, title: 'My Active Campaign', school: school, creator: creator, status: 'active') }

  scenario 'campaign is not visible in searches until it is active', js: true do
    visit schools_path
    search_for_school('my school')

    within "#school_#{school.id}" do
      expect(page).to have_content(/My School/i)
      expect(page).to_not have_content 'My Draft Campaign'
      expect(page).to have_content 'My Active Campaign'
    end
  end

  scenario 'cannot visit a campaign that has not been activated' do
    visit campaign_path(draft_campaign)
    expect(page).to have_content 'not authorized'
  end
end

feature 'Campaign management and accessibility' do
  given!(:user) { login Fabricate(:user, email: 'josh@meetmaestro.com', password: 'password', password_confirmation: 'password') }
  given!(:school) { Fabricate(:school, name: 'My School', city: 'Grand Rapids', region: 'Michigan') }

  given(:campaign) { Fabricate(:campaign, title: 'My Campaign', school: school, creator: creator, status: status) }

  context 'as the owner' do
    let(:creator) { user }

    context 'with an unsaved campaign' do
      let(:status) { 'unsaved' }

      scenario 'saves campaign without submitting', js: true do
        visit new_school_campaign_path(school)
        fill_in 'campaign_title', with: 'My Campaign Title modified'
        click_link 'Save and Preview'
        expect(page).to have_content(/draft/i)
      end

      scenario 'cancels campaign creation' do
        visit new_school_campaign_path(school)
        click_link 'Cancel'
        expect(page).to have_content 'successfully deleted'
      end
    end

    context 'with a draft campaign' do
      let(:status) { 'draft' }

      scenario 'saves campaign without submitting', js: true do
        visit edit_campaign_path(campaign)
        fill_in 'campaign_title', with: 'My Campaign Title modified'
        click_link 'Save and Preview'
        expect(page).to have_content(/draft/i)
      end

      scenario 'submits campaign for approval' do
        visit campaign_path(campaign)
        accept_the_terms
        click_button 'Submit for Approval'
        expect(page).to have_content(/awaiting approval/i)
      end
    end

    context 'with a submitted campaign' do
      let(:status) { 'awaiting_approval' }

      scenario 'edits a submitted campaign without resubmitting', js: true do
        visit edit_campaign_path(campaign)
        fill_in 'campaign_summary', with: 'Abridged summary.'
        click_link 'Save and Preview'
        expect(page).to have_content(/draft/i)
        expect(page).to have_content('Abridged summary.')
      end

      scenario 'cannot approve a campaign' do
        visit campaign_path(campaign)
        expect(page).to_not have_button 'Approve Campaign'
      end

      scenario 'can cancel their campaign', js: true do
        visit campaign_path(campaign)
        click_button 'Cancel'
        expect(page).to have_content 'successfully updated'
        expect(page).to have_content(/draft/i)
      end
    end

    %w(awaiting_approval awaiting_contract pending_activation rejected).each do |status|
      context "with status #{status}" do
        let(:status) { status }

        scenario 'cancels the campaign' do
          visit campaign_path(campaign)
          click_button 'Cancel Campaign'
          expect(page).to have_content(/draft/i)
        end
      end
    end

    context 'with a campaign pending activation' do
      let(:status) { 'pending_activation' }

      scenario 'can activate the campaign' do
        visit campaign_path(campaign)
        click_button 'Activate Campaign'

        expect(page).to have_content('successfully updated')
        expect(page).to have_css('#donation .donation-buttons')
      end
    end
  end

  context 'as a school administrator' do
    background { user.school_roles.create!(name: 'school_admin', school_id: school.id).verify! }
    let(:creator) { Fabricate(:user) }

    context 'with a campaign they created' do
      let(:creator) { user }

      %i(draft awaiting_approval).each do |status|
        context "with status #{status}" do
          let(:status) { status }

          scenario "approves the campaign" do
            visit campaign_path(campaign)
            accept_the_terms
            click_button 'Approve Campaign'
            expect(page).to have_content(/awaiting contract/i)
          end

          scenario 'skips the submit for approval step from preview' do
            visit campaign_path(campaign)
            expect(page).to_not have_button 'Submit for Approval'
          end

          scenario 'skips the submit for approval step from edit' do
            visit edit_campaign_path(campaign)
            expect(page).to_not have_button 'Submit for Approval'
            expect(page).to_not have_button 'Resubmit Campaign'
          end

          scenario 'cannot approve the campaign while editing' do
            visit edit_campaign_path(campaign)
            expect(page).to_not have_button 'Approve Campaign'
          end

          scenario 'cannot reject the campaign' do
            visit campaign_path(campaign)
            expect(page).to_not have_button 'Reject Campaign'
          end
        end
      end

      %w(awaiting_approval awaiting_contract pending_activation rejected).each do |status|
        context "with status #{status}" do
          let(:status) { status }

          scenario 'cancels the campaign' do
            visit campaign_path(campaign)
            click_button 'Cancel Campaign'
            expect(page).to have_content(/draft/i)
          end
        end
      end

      context 'in an unsaved status' do
        let(:status) { 'unsaved' }

        scenario 'cannot approve the campaign' do
          visit campaign_path(campaign)
          expect(page).to_not have_button 'Approve Campaign'
        end

        scenario 'can approve the campaign once it has been saved' do
          visit edit_campaign_path(campaign)
          fill_in 'campaign_title', with: 'Changed Campaign'
          click_button 'Save and Preview'

          expect(page).to have_content(/Changed Campaign/i)
          expect(page).to have_button 'Approve Campaign'
        end
      end
    end # admin-created campaign

    context "with a campaign awaiting_approval" do
      let(:status) { 'awaiting_approval' }

      context 'from their school' do
        scenario 'approves the campaign' do
          visit campaign_path(campaign)
          accept_the_terms
          click_button 'Approve Campaign'
          expect(page).to have_content(/awaiting contract/i)
        end

        scenario 'rejects the campaign' do
          visit campaign_path(campaign)
          click_button 'Reject Campaign'
          # fill_in 'rejection_reason', with: "because #{Faker::Company.bs} is not allowed"
          # click_button 'Confirm Rejection'
          expect(page).to have_content(/rejected/i)
        end
      end
    end

    context "with a campaign awaiting_contract" do
      let(:status) { 'awaiting_contract' }

      context 'from their school' do
        scenario 'cannot approve the campaign' do
          visit campaign_path(campaign)
          expect(page).to_not have_button('Approve Campaign')
        end

        scenario 'rejects the campaign' do
          visit campaign_path(campaign)
          click_button 'Reject Campaign'
          # fill_in 'rejection_reason', with: "because #{Faker::Company.bs} is not allowed"
          # click_button 'Confirm Rejection'
          expect(page).to have_content(/rejected/i)
        end
      end
    end

    context 'with a campaign pending activation' do
      let(:status) { 'pending_activation' }

      scenario 'can activate the campaign' do
        visit campaign_path(campaign)
        click_button 'Activate Campaign'

        expect(page).to have_content('successfully updated')
        expect(page).to have_css('#donation .donation-buttons')
      end
    end
  end
end

feature 'Submitting school affiliation' do
  given!(:user) { login Fabricate(:user, email: 'josh@meetmaestro.com', password: 'password', password_confirmation: 'password') }
  given!(:school) { Fabricate(:school, name: 'My School', city: 'Grand Rapids', region: 'Michigan') }

  background { visit new_school_campaign_path(school) }

  scenario 'creates an unverified school role for the user' do
    fill_in_campaign_form
    select_affiliation 'School Administrator'

    click_button 'Save and Preview'

    role = SchoolRole.last
    role.should_not be_verified
    role.school.should eq(school)
    role.user.should eq(user)
    role.name.should eq('school_admin')
  end
end

private

def navigate_to_new_campaign_for(school_name)
  visit root_path
  click_button 'Start a Campaign'

  search_for_school(school_name) { find_link('New Campaign').click }
end

def search_for_school(school_name, &block)
  within '#main' do
    fill_in 'query', with: school_name
    yield if block_given?
  end
end

def fill_in_campaign_form
  fill_in 'campaign_title', with: 'My New Campaign'
  #fill_in 'campaign_twitter_username', with: 'horse_ebooks'
  fill_in 'campaign_summary', with: Faker::Lorem.paragraphs(5).join("\n\n")
end

def accept_the_terms
  check 'campaign[terms_of_service]', visible: false
end

def select_affiliation(affiliation)
  choose affiliation
end
