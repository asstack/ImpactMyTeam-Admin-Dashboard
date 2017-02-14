require 'spec_helper'

describe DonationTransaction do
  it { should belong_to :donation }

  describe 'scopes' do
    context 'on success' do
      let!(:successful) { Fabricate(:donation_transaction, success: true) }
      let!(:failed) { Fabricate(:donation_transaction, success: false) }

      describe '.successful' do
        subject { DonationTransaction.successful }

        it { should == [successful] }
      end

      describe '.failed' do
        subject { DonationTransaction.failed }

        it { should == [failed] }
      end
    end
  end
end
