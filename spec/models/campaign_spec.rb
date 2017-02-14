require 'spec_helper'

describe Campaign do
  specify { Fabricate(:campaign).should be_persisted }
  it { should belong_to :school }
  it { should belong_to(:team).class_name('SchoolTeam') }
  it { should belong_to(:creator).class_name('User') }

  it { should have_one(:shopping_cart).dependent(:destroy) }
  it { should have_many(:donations).dependent(:restrict) }

  it 'creates a shopping cart when it is created' do
    campaign = Campaign.new(title: 'title!')
    campaign.shopping_cart.should be_nil

    campaign.save!
    campaign.shopping_cart.should be_a(ShoppingCart)
  end

  it 'cannot be deleted if it has any donations' do
    campaign = Fabricate(:campaign, goal_amount: 10000.00, status: 'active', with_donations: true)
    campaign.donations.should_not be_empty
    expect { campaign.destroy }
      .to raise_error ActiveRecord::DeleteRestrictionError
  end

  describe '#collected_donations.total' do
    let!(:campaign) { Fabricate(:campaign, status: 'active') }

    it 'sums the captured amounts from collected donations' do
      3.times { |i| Fabricate(:donation, campaign: campaign, amount_captured: (i + 1) * 5.00, status: 'collected') }
      campaign.collected_donations.total.should == 30.00
    end

    %w(pending authorized denied).each do |donation_status|
      it "ignores #{donation_status} donations" do
        3.times { |i| Fabricate(:donation, campaign: campaign, amount_captured: nil, status: donation_status) }
        campaign.collected_donations.total.should == 0.00
      end
    end
  end

  describe '#goal_remaining' do
    let!(:campaign) { Fabricate(:campaign, goal_amount: 300.00) }

    it 'shows the difference between goal amount and total collected donations' do
      campaign.collected_donations.stub(total: 224.75)
      campaign.goal_remaining.should == 75.25
    end
  end

  describe '#goal_completed?' do
    let(:campaign) { Fabricate(:campaign, goal_amount: 300.00) }

    it 'is false if total collected donations is less than the goal amount' do
      campaign.collected_donations.stub(total: 299.99)
      campaign.goal_completed?.should be_false
    end

    it 'is true if total collected donations is equal to the goal amount' do
      campaign.collected_donations.stub(total: 300.00)
      campaign.goal_completed?.should be_true
    end

    it 'is true if total collected donations is more than the goal amount' do
      campaign.collected_donations.stub(total: 300.01)
      campaign.goal_completed?.should be_true
    end
  end

  describe '#goal_progress' do
    it 'works okay if goal_amount is zero' do
      campaign = Fabricate(:campaign, goal_amount: 0.00)
      expect { campaign.goal_progress }.to_not raise_error
    end
    it 'returns a float' do
      campaign = Fabricate(:campaign, goal_amount: 1000.00)
      campaign.collected_donations.stub(total: 100)
      campaign.goal_progress.should be_a(Float)
      campaign.goal_progress.should == 0.1
    end
  end

  describe 'status' do
    subject(:campaign) { Fabricate(:campaign, status: status, goal_amount: 0.00) }

    describe ':unsaved' do
      let(:status) { 'unsaved' }

      specify { Fabricate(:campaign).should be_unsaved }
      it { should be_unsaved }
      it { should_not validate_presence_of :title }
      it { should_not validate_acceptance_of :terms_of_service }

      it 'can be marked as draft' do
        expect { campaign.mark_as_draft! }
          .to change { campaign.status }.to('draft')
      end

      it 'can be submitted' do
        expect { campaign.submit! }
          .to change { campaign.status }.to('awaiting_approval')
      end
    end

    describe ':draft' do
      let(:status) { 'draft' }

      it { should be_draft }
      it { should validate_presence_of :title }
      it { should_not validate_acceptance_of :terms_of_service }

      it 'can be submitted for approval' do
        expect { campaign.submit! }
          .to change{campaign.status}.to('awaiting_approval')
      end

      it 'can be approved' do
        expect { campaign.approve! }
          .to change{campaign.status}.to('awaiting_contract')
      end

      %w(accept_contract! activate! close!).each do |event|
        it "raises an error transitioning via #{event}" do
          expect { campaign.send(event) }.to raise_error
        end
      end
    end

    describe ':rejected' do
      let(:status) { 'awaiting_approval' }
      before { campaign.reject! }

      it { should be_rejected }

      it 'can be resubmitted' do
        expect { campaign.submit! }
          .to change{campaign.status}.to('awaiting_approval')
      end

      it 'can be marked as draft' do
        expect { campaign.mark_as_draft! }
          .to change { campaign.status }.to('draft')
      end

      it 'can be canceled' do
        expect { campaign.cancel! }
          .to change{campaign.status}.to('draft')
      end
    end

    describe ':awaiting_approval' do
      let(:status) { 'awaiting_approval' }

      it { should be_awaiting_approval }
      it { should validate_presence_of :title }
      it { should validate_acceptance_of :terms_of_service }

      it 'can be marked as draft' do
        expect { campaign.mark_as_draft! }
          .to change {campaign.status}.to('draft')
      end

      it 'can be rejected' do
        expect { campaign.reject! }
          .to change {campaign.status}.to('rejected')
      end

      it 'can be resubmitted for approval' do
        expect { campaign.submit! }
          .to_not change { campaign.status }
      end

      it 'can be approved' do
        expect { campaign.approve! }
          .to change{campaign.status}.to('awaiting_contract')
      end

      it 'can be canceled' do
        expect { campaign.cancel! }
          .to change{campaign.status}.to('draft')
      end

      %w(accept_contract! activate! close!).each do |event|
        it "raises an error transitioning via #{event}" do
          expect { campaign.send(event) }.to raise_error
        end
      end
    end

    describe ':awaiting_contract' do
      let(:status) { 'awaiting_contract' }

      it { should be_awaiting_contract }
      it { should validate_presence_of :title }
      it { should validate_acceptance_of :terms_of_service }

      it 'can accept a contract' do
        expect { campaign.accept_contract! }
          .to change{campaign.status}.to('pending_activation')
      end

      it 'can be canceled' do
        expect { campaign.cancel! }
          .to change{campaign.status}.to('draft')
      end

      it 'can be rejected' do
        expect { campaign.reject! }
          .to change {campaign.status}.to('rejected')
      end

      %w(activate! close!).each do |event|
        it "raises an error transitioning via #{event}" do
          expect { campaign.send(event) }.to raise_error
        end
      end
    end

    describe ':pending_activation' do
      let(:status) { 'pending_activation' }

      it { should be_pending_activation }
      it { should validate_presence_of :title }
      it { should validate_acceptance_of :terms_of_service }

      it 'can be canceled' do
        expect { campaign.cancel! }
          .to change{campaign.status}.to('draft')
      end

      it 'can be activated' do
        expect { campaign.activate! }
          .to change{campaign.status}.to('active')
      end

      describe '#activate!' do
        before { Timecop.freeze(Time.zone.now) }
        after { Timecop.return }

        it 'sets the start date' do
          expect { campaign.activate! }
            .to change{campaign.start_date}.from(nil).to(Time.zone.today)
        end

        it 'sets the end date based on duration' do
          expect { campaign.activate! }
            .to change{campaign.end_date}.from(nil).to(Time.zone.today + campaign.duration_in_days.days)
        end

        it 'sets the goal amount to the order total of its shopping cart' do
          ShoppingCart.any_instance.stub(order_total: 8995.00)

          expect { campaign.activate! }
            .to change{campaign.goal_amount}.from(0.00).to(8995.00)
        end
      end
    end

    describe ':active' do
      let(:status) { 'active' }

      it { should be_active }

      it 'can be closed' do
        expect { campaign.close! }
          .to change { campaign.status }.to('closed')
      end
    end

    describe '#close!' do
      let(:status) { 'closed' }

      it { should be_closed }
      it { should validate_presence_of :title }
      it { should validate_acceptance_of :terms_of_service }
    end
  end
end
