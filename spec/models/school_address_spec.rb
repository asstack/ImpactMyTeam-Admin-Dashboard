require 'spec_helper'

describe SchoolAddress do
  specify { Fabricate.build(:school_address).should be_valid }

  it { should belong_to(:school) }

  it { should validate_presence_of(:line_1) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:region) }
  it { should validate_presence_of(:postal_code) }
  it { should validate_presence_of(:country) }

  it { should ensure_inclusion_of(:address_type).in_array(SchoolAddress.address_types) }
end
