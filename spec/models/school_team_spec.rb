require 'spec_helper'

describe SchoolTeam do
  specify { Fabricate.build(:team).should be_valid }

  it { should belong_to :school }
  it { should belong_to :athletic_conference }
  it { should belong_to :school_contact }
end
