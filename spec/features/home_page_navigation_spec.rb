require 'spec_helper'

feature 'The navigation bar', js: true do
  let!(:user) { Fabricate(:user, password: 'password', password_confirmation: 'password') }
  context 'as a guest' do
    before { visit root_path }

    describe 'can sign in with valid credentials' do
      before do
        login_with_credentials user.email, 'password', via: 'header'
      end

      specify { page.should have_content 'Signed in successfully' }
      specify { page.should have_content user.name }
    end
  end
end

feature 'The home page' do
  context 'as a guest' do
    before { visit root_path }

    subject { page }

    it { should have_button "Start a Campaign" }
    it { should have_link "Success Stories" }
    it { should have_link "What is Impact Your Team?" }
  end
end

feature 'The footer' do
  before { visit root_path }

  ['Contact', 'About', 'Terms Of Use', 'Privacy Policy', 'Guidelines', 'Agreement'].each do |page_link|
    it "has a link to #{page_link}" do
      within 'footer' do
        expect(page).to have_link(page_link)
      end
    end
  end
end

