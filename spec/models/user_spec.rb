require 'spec_helper'

describe User do
  specify { Fabricate.build(:user).should be_valid }

  it { should validate_uniqueness_of(:email) }

  it { should allow_mass_assignment_of :first_name }
  it { should allow_mass_assignment_of :last_name }
  it { should allow_mass_assignment_of :phone_number }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }

  it { should have_many(:school_roles).dependent(:destroy) }
  it { should have_many(:schools).through(:school_roles) }

  it { should have_many(:campaigns) }

end
