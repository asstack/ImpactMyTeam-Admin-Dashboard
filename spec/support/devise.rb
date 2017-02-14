module FeatureHelpers
  def login(user)
    login_as user, scope: :user
    user
  end

  def login_with_credentials(email, password, via: nil)
    page.execute_script('$("#user-menu").toggleClass("visible")') if via == 'header'

    within "##{via || 'main'}" do
      fill_in [via, 'user_email'].compact.join('_'), with: email
      fill_in [via, 'user_password'].compact.join('_'), with: password

      if example.metadata[:js]
        find(:button, 'Sign in').trigger('click')
      else
        click_button 'Sign in'
      end
    end
  end

  def register_user(options = {})
    {
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@example.com',
      phone_number: '616-555-3320',
      password: 'password',
      password_confirmation: 'password'
    }.merge!(options).each do |field, value|
      within '#main' do
        fill_in "user_#{field}", with: value
      end
    end

    click_button 'Register'
  end
end

module ControllerHelpers
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
    user
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller

  config.include FeatureHelpers, type: :feature

  config.before(:all) do
    Warden.test_mode!
  end

  config.after(:all) do
    Warden.test_reset!
  end
end
