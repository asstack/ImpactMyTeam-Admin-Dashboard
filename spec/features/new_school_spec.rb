require 'spec_helper'

feature 'Creating a new school' do
  context 'as a guest' do
    let(:user) { Fabricate(:user, password: 'password', password_confirmation: 'password') }

    scenario 'should require login or registration' do
      visit new_school_path

      current_path.should == new_user_session_path

      login_with_credentials user.email, 'password'

      current_path.should == new_school_path
    end
  end

  context 'as a logged in user' do
    let!(:user) { login Fabricate(:user) }

    scenario 'can create a school' do
      visit new_school_path

      fill_in_school_form

      expect(page).to have_content(/successfully created/)
      expect(page).to have_content(/My School/i)

      user.school_roles.for_school(School.last).size.should == 1
    end
  end
end

feature 'Editing an existing school' do
  let!(:user) { login Fabricate(:user) }
  let!(:school) { Fabricate(:school_full) }

  context 'as an unaffiliated user' do
    scenario 'I cannot edit the school' do
      visit edit_school_path(school)

      current_path.should_not == edit_school_path(school)
      expect(page).to have_content(/not authorized/i)
    end

    scenario 'cannot get to the edit page' do
      visit school_path(school)
      expect(page).to_not have_link('Edit School', href: edit_school_path(school))
    end
  end

  context 'as a school administrator' do
    before { school.school_roles.create!(name: 'school_admin', user_id: user.id).tap(&:verify!) }

    scenario 'I can update the school' do
      visit edit_school_path(school)

      fill_in 'school_name', with: 'Some kind of new school name'

      click_button 'Update School'

      expect(page).to have_content(/successfully updated/i)
      expect(page).to have_content(/Some kind of new school name/i)
      current_path.should == school_path(school)
    end

    scenario 'getting to the edit page' do
      visit school_path(school)
      click_link 'Edit School'
      current_path.should == edit_school_path(school)
    end
  end
end

def fill_in_school_form
  fill_in 'school_name', with: 'My School'
  fill_in 'school_city', with: 'Washington'
  fill_in 'school_region', with: 'Michigan'
  select 'Public', from: 'school_school_type'
  select 'Secondary', from: 'school_school_level'

  fill_in 'school_addresses_attributes_0_phone_number', with: Faker::PhoneNumber.phone_number
  fill_in 'school_addresses_attributes_0_line_1', with: Faker::Address.street_address
  fill_in 'school_addresses_attributes_0_city', with: Faker::Address.city
  fill_in 'school_addresses_attributes_0_region', with: Faker::Address.state
  fill_in 'school_addresses_attributes_0_postal_code', with: Faker::Address.zip_code

  select SchoolContact.contact_types.sample, from: 'school_contacts_attributes_0_contact_type'
  fill_in 'school_contacts_attributes_0_email', with: Faker::Internet.email
  fill_in 'school_contacts_attributes_0_first_name', with: Faker::Name.first_name
  fill_in 'school_contacts_attributes_0_last_name', with: Faker::Name.last_name
  fill_in 'school_contacts_attributes_0_phone_number', with: Faker::PhoneNumber.phone_number

  choose SchoolRole.role_mappings.keys.sample

  click_button 'Create School'
end
