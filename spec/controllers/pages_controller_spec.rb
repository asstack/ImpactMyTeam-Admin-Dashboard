require 'spec_helper'

describe PagesController do
  describe "GET #show with permalink" do
    let!(:page) { Fabricate(:page, permalink: 'privacy-policy') }
    before { get :show, id: 'privacy-policy' }

    it { should respond_with :success }
    specify { assigns(:page).should eq(page) }
  end
end
