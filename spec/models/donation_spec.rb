require 'spec_helper'

describe Donation do
  let(:campaign) { Fabricate(:campaign, goal_amount: 10000) }

  specify { Fabricate(:donation, campaign: campaign).should be_persisted }

  it { should belong_to :campaign }
  it { should have_many(:transactions)
        .class_name('DonationTransaction')
        .dependent(:restrict)
        .order('created_at ASC')
      }

  it { should validate_acceptance_of :terms_of_service }

  it 'does not persist credit card information', :vcr do
    # we test this by making sure a donation cannot be
    # authorized if loaded from the database
    donation_id = Fabricate(:donation, campaign: campaign).id
    donation = Donation.find(donation_id)
    donation.authorize
    transaction = donation.transactions.last
    transaction.success.should be_false
    transaction.message.should =~ /Invalid Credit Card Number/i
  end

  describe 'on create' do
    it 'validates the credit card' do
      donation = Donation.new
      donation.should_not be_valid
    end
  end

  describe '#authorize', :vcr do
    let(:donation) { Fabricate(:donation, campaign: campaign, amount_authorized: amount) }

    context 'with a successful response' do
      let(:amount) { rand(100) + rand(100) / 100.0 } # some valid amount

      it 'creates a record of the transaction' do
        expect { donation.authorize }
          .to change { donation.transactions.count }.by(1)
      end

      it 'has a successul response' do
        donation.authorize
        transaction = donation.transactions.last
        transaction.success.should be_true
      end

      it 'has the correct authorized amount' do
        donation.update_attributes(amount_authorized: 20.00)
        donation.authorize
        donation.amount_authorized.should eq(20.00)
        donation.transactions.last.amount.should eq(20.00)
      end

      it 'has status: authorized' do
        expect { donation.authorize }
          .to change{donation.status}.from('pending').to('authorized')
      end
    end

    context 'with a failed response' do
      let(:amount) { 5000 + error_code + ecommerce_code / 100.0 }
      let(:error_code) { 1 }
      let(:ecommerce_code) { 0 }

      it 'creates a record of the transaction' do
        expect { donation.authorize }
          .to change { donation.transactions.count }.by(1)
      end

      it 'has a failed response' do
        donation.authorize
        transaction = donation.transactions.last
        transaction.success.should be_false
      end

      it 'has status: denied' do
        expect { donation.authorize }
          .to change { donation.status }.from('pending').to('denied')
      end
    end
  end

  describe '#collect_funds', :vcr do
    let(:donation) { Fabricate(:donation, campaign: campaign, amount_authorized: amount).tap(&:authorize!) }

    context 'with a successful response' do
      let(:amount) { rand(100) + rand(100) / 100.0 } # some valid amount

      it 'creates a record of the transaction' do
        expect { donation.collect_funds }
          .to change { donation.transactions.count }.by(1)
      end

      it 'has a successul response' do
        donation.collect_funds
        transaction = donation.transactions.last
        transaction.success.should be_true
      end

      context 'with a known amount' do
        let(:amount) { 20.00 }
        it 'has the correct authorized amount' do
          donation.collect_funds!
          donation.amount_captured.should eq(20.00)
          donation.transactions.last.amount.should eq(20.00)
        end
      end

      it 'has status: collected' do
        expect { donation.collect_funds }
          .to change{donation.status}.from('authorized').to('collected')
      end
    end

    context 'with a failed response' do
      let(:amount) { 5000 + error_code + ecommerce_code / 100.0 }
      let(:error_code) { 0 }
      let(:ecommerce_code) { 0 }

      before do
        # force a failed collection
        donation.transactions.last.update_attributes(amount: 5001.00)
      end

      it 'creates a record of the transaction' do
        expect { donation.collect_funds }
          .to change { donation.transactions.count }.by(1)
      end

      it 'has a failed response' do
        donation.collect_funds
        transaction = donation.transactions.last
        transaction.success.should be_false
      end

      it 'has status: authorized' do
        expect { donation.collect_funds }
          .to_not change { donation.status }.from('authorized')
      end
    end
  end
end
