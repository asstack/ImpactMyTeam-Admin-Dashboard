require 'spec_helper'

describe 'Admin schools' do
  before { login Fabricate(:admin_user) }

  describe 'new school' do
    before { visit new_admin_school_path }

    it 'has fields for an address' do
      within '.addresses' do
        expect(page).to have_field 'City'
      end
    end

    it 'has fields for a contact' do
      within '.contacts' do
        expect(page).to have_field 'First name'
        expect(page).to have_field 'Phone number'
      end
    end
  end
end
