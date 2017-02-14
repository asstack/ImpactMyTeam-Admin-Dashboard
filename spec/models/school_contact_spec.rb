require 'spec_helper'

describe SchoolContact do
  specify { Fabricate.build(:contact).should be_valid }

  it { should belong_to :school }
  it { should have_many(:teams).class_name('SchoolTeam') }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :phone_number }
  it { should ensure_inclusion_of(:contact_type).in_array(SchoolContact.contact_types) }
end
