require 'spec_helper'

describe School do
  specify { Fabricate(:school).should be_persisted }
  specify { Fabricate(:school_full).should be_persisted }

  it { should have_many(:school_roles).dependent(:destroy) }
  it { should have_many(:school_affiliates).through(:school_roles).class_name('User') }

  it { should have_many(:addresses).class_name('SchoolAddress').dependent(:destroy) }
  it { should accept_nested_attributes_for(:addresses) }
  it { should allow_mass_assignment_of(:addresses_attributes) }

  it { should have_many(:contacts).class_name('SchoolContact') }
  it { should accept_nested_attributes_for(:contacts) }
  it { should allow_mass_assignment_of(:contacts_attributes) }

  it { should have_many(:teams).class_name('SchoolTeam').dependent(:destroy) }

  it { should have_many :campaigns }

  it { should validate_presence_of :name }
  it { should validate_presence_of :city }
  it { should validate_presence_of :region }

  it { should ensure_inclusion_of(:school_level).in_array(School.school_levels) }
  it { should ensure_inclusion_of(:school_type).in_array(School.school_types) }

  describe '.search_by_full_name' do
    let!(:robin) { Fabricate(:school, name: 'Batman and Robin', city: 'Van Buren', region: 'North Dakota') }
    let!(:alfred) { Fabricate(:school, name: 'Batman and Alfred', city: 'Art Van', region: 'West Dakota') }
    let!(:neither) { Fabricate(:school, name: 'Super', city: 'Grand Rapids', region: 'Michigan') }

    it 'searches the name, city, and region fields' do
      School.search_by_full_name('Batman Van Dakota').should =~ [robin, alfred]
    end

    it 'returns none if no query is provided' do
      School.search_by_full_name('').should be_empty
    end

    describe 'partial searches' do
      it 'finds records with only part of the word' do
        School.search_by_full_name('bat').should =~ [robin, alfred]
      end

      it 'finds records with partial words in multiple columns' do
        School.search_by_full_name('bat van').should =~ [robin, alfred]
      end
    end
  end

end
