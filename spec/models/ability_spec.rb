require 'spec_helper'
require 'cancan/matchers'

describe 'Abilities' do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:user) { nil }

  let(:school) { Fabricate(:school) }
  let(:campaign) { Fabricate(:campaign, school: school, creator: creator, status: status) }

  context 'as an admin' do
    let(:user) { Fabricate(:admin_user) }
    let(:creator) { Fabricate(:user) }

    # State-based restrictions
    context 'an unsaved campaign' do
      let(:status) { 'unsaved' }

      %i(reject cancel accept_contract activate close).each do |ability|
        it { should_not be_able_to ability, campaign }
      end
    end

    context 'a draft campaign' do
      let(:status) { 'draft' }

      %i(reject accept_contract activate close).each do |ability|
        it { should_not be_able_to ability, campaign }
      end
    end

    context 'a submitted campaign' do
      let(:status) { 'awaiting_approval' }

      restricted = %i(accept_contract activate close)
      allowed = Campaign.state_machine(:status).events.map(&:name) - restricted

      restricted.each do |ability|
        it { should_not be_able_to ability, campaign }
      end

      allowed.each do |ability|
        it { should be_able_to ability, campaign }
      end
    end

    context 'an approved campaign' do
      let(:status) { 'awaiting_contract' }

      restricted = %i(submit mark_as_draft activate close)
      allowed = Campaign.state_machine(:status).events.map(&:name) - restricted

      restricted.each do |ability|
        it { should_not be_able_to ability, campaign }
      end

      allowed.each do |ability|
        it { should be_able_to ability, campaign }
      end
    end

    context 'a campaign awaiting activation' do
      let(:status) { 'pending_activation' }

      restricted = %i(mark_as_draft submit approve accept_contract reject close)
      allowed = Campaign.state_machine(:status).events.map(&:name) - restricted

      restricted.each do |ability|
        it { should_not be_able_to ability, campaign }
      end

      allowed.each do |ability|
        it { should be_able_to ability, campaign }
      end
    end

    context 'an active campaign' do
      let(:status) { 'active' }

      restricted = %i(mark_as_draft submit approve accept_contract reject activate cancel)
      allowed = Campaign.state_machine(:status).events.map(&:name) - restricted

      restricted.each do |ability|
        it { should_not be_able_to ability, campaign }
      end

      allowed.each do |ability|
        it { should be_able_to ability, campaign }
      end
    end

    context 'a closed campaign' do
      let(:status) { 'closed' }

      restricted = %i(mark_as_draft submit approve accept_contract reject close cancel)
      allowed = Campaign.state_machine(:status).events.map(&:name) - restricted

      restricted.each do |ability|
        it { should_not be_able_to ability, campaign }
      end

      allowed.each do |ability|
        it { should be_able_to ability, campaign }
      end
    end
  end

  context 'as guest' do
    it { should be_able_to :read, school }
    it { should_not be_able_to :create, School }
    it { should be_able_to :read, Fabricate(:campaign, school: school, status: 'active') }
  end

  context 'as registered user' do
    let(:user) { Fabricate(:user) }

    it { should be_able_to :read, school }
    it { should be_able_to :create, School }

    it { should be_able_to :create, Campaign }

    context 'with a campaign I create' do
      let(:creator) { user }

      %w(unsaved draft awaiting_approval rejected).each do |status|
        context "when #{status}" do
          let(:status) { status }

          %i(read update submit destroy).each do |action|
            it { should be_able_to action, campaign }
          end

          %i(approve).each do |action|
            it { should_not be_able_to action, campaign }
          end

          describe 'its shopping cart' do
            %i(read update).each do |action|
              it { should be_able_to action, campaign.shopping_cart }
            end
          end
        end
      end

      %w(awaiting_approval awaiting_contract pending_activation rejected).each do |status|
        context "when #{status}" do
          let(:status) { status }

          it { should be_able_to :cancel, campaign }
        end
      end


      context 'when pending_activation' do
        let(:status) { 'pending_activation' }
        it { should be_able_to :activate, campaign }
      end
    end

    context 'with a campaign I did not create' do
      let(:creator) { Fabricate(:user) }

      %w(unsaved draft awaiting_approval rejected pending_activation).each do |status|
        context "when #{status}" do
          let(:status) { status }

          %i(read update submit destroy approve activate).each do |action|
            it { should_not be_able_to action, campaign }
          end
        end
      end

      context 'when pending_activation' do
        let(:status) { 'pending_activation' }
        it { should_not be_able_to :activate, campaign }
      end
    end

    context 'with public campaigns' do
      let(:creator) { Fabricate(:user) }
      %w(active closed).each do |status|
        let(:status) { status }

        it { should be_able_to :read, campaign }
      end
    end
  end

  %w(school_admin athletic_director).each do |school_role|
    context "as #{school_role}" do
      let(:user) { Fabricate(:user).tap{|u| u.school_roles.create!(name: school_role, school_id: my_school.id).verify! } }
      let(:my_school) { Fabricate(:school) }

      specify { user.schools.managed.verified.should eq([my_school]) }

      it { should be_able_to :read, my_school }
      it { should be_able_to :update, my_school }
      it { should_not be_able_to :update, school }

      context 'with campaigns I created' do
        context 'with my school' do
          let(:creator) { user }
          let(:school) { my_school }

          %w(draft awaiting_approval).each do |status|
            context "when #{status}" do
              let(:status) { status }

              %i(approve).each do |action|
                it { should be_able_to action, campaign }
              end

              %i(reject).each do |action|
                it { should_not be_able_to action, campaign }
              end
            end
          end

          context 'when pending_activation' do
            let(:status) { 'pending_activation' }
            it { should be_able_to :activate, campaign }
          end
        end

        context 'with a school I do not manage' do
          let(:creator) { user }
          let(:school) { Fabricate(:school) }

          %w(unsaved draft awaiting_approval rejected).each do |status|
            context "when #{status}" do
              let(:status) { status }
              %i(approve reject).each do |action|
                it { should_not be_able_to action, campaign }
              end
            end
          end

          context 'when pending_activation' do
            let(:status) { 'pending_activation' }
            it { should be_able_to :activate, campaign }
          end
        end
      end

      context 'campaigns associated with my school' do
        let(:creator) { Fabricate(:user) }
        let(:school) { my_school }

        %w(unsaved draft).each do |status|
          context "when #{status}" do
            let(:status) { status }

            %i(read approve reject).each do |action|
              it { should_not be_able_to action, campaign }
            end
          end
        end

        %w(rejected awaiting_contract pending_activation).each do |status|
          context "when #{status}" do
            let(:status) { status }

            %i(read).each do |action|
              it { should be_able_to action, campaign }
            end
          end
        end

        context 'when awaiting_approval' do
          let(:status) { 'awaiting_approval' }

          %i(read approve reject).each do |action|
            it { should be_able_to action, campaign }
          end
        end

        context 'when pending_activation' do
          let(:status) { 'pending_activation' }
          it { should be_able_to :activate, campaign }
        end
      end

      context 'campaigns not associated with my school' do
        let(:creator) { Fabricate(:user) }

        %w(unsaved draft rejected awaiting_approval awaiting_contract pending_activation).each do |status|
          context "when #{status}" do
            let(:status) { status }

            %i(read approve reject submit activate).each do |action|
              it { should_not be_able_to action, campaign }
            end
          end
        end
      end
    end
  end
end
