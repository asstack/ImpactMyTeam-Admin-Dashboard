require 'spec_helper'

describe "Campaigns" do
  let(:school) { Fabricate(:school) }

  describe "GET /schools" do
    describe '#index' do
      before { get schools_path }
      specify { response.status.should be 200 }
    end

    describe '#show' do
      before { get school_path(school) }
      specify { response.status.should be 200 }
    end
  end
end
