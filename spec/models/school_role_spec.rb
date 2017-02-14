require 'spec_helper'

describe SchoolRole do
  it { should belong_to(:user) }
  it { should belong_to(:school) }
  it { should belong_to(:verified_by).class_name('User') }

  it { should validate_presence_of(:name) }
  it { should ensure_inclusion_of(:name).in_array(SchoolRole.roles) }

  describe '.roles' do
    specify { SchoolRole.roles.should =~ %w(school_admin athletic_director booster parent student other) }
  end

  describe '#verify!' do
    let(:verifier) { Fabricate(:user).tap{ |u| u.grant :admin } }
    let(:role) { SchoolRole.create!(name: 'school_admin', school_id: Fabricate(:school).id, user_id: Fabricate(:user).id) }
    it 'sets the validation time' do
      expect { role.verify! }.to change {role.verified_at}.from(NilClass)
    end

    it 'records the verifier' do
      expect { role.verify!(verifier) }.to change{ role.verified_by }.from(nil).to(verifier)
    end
  end
end
