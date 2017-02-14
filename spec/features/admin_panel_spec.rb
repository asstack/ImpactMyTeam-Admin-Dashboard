require 'spec_helper'

describe 'Admin Panel' do
  describe 'as a general user' do
    before do
      login Fabricate(:user)
      visit admin_root_path
    end

    it 'flashes an error access' do
      expect(page).to have_text 'restricted'
    end

    it 'does not bring me to the admin panel' do
      current_path.should_not == admin_root_path
    end

    it 'redirects to application root' do
      current_path.should == root_path
    end
  end

  describe 'as an admin user' do
    before do
      login Fabricate(:admin_user)
      visit admin_root_path
    end

    it 'brings me to the admin panel' do
      current_path.should == admin_root_path
    end
  end
end
