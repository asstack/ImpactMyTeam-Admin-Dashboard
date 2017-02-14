require 'spec_helper'

describe DashboardController do
  describe "GET 'index'" do

    context 'as a guest' do
      before { get :index }
      it { should redirect_to new_user_session_path }
      it { should set_the_flash }
    end

    context 'as a logged in user' do
      let!(:user) { login Fabricate(:user) }

      before { get :index }

      it { should respond_with :success }
    end
  end
end
