require 'spec_helper'

describe AthleticConference do
  specify { Fabricate.build(:conference).should be_valid }

  it { should have_many(:teams).class_name('SchoolTeam') }
end
