require 'spec_helper'

describe DonationsController do
  describe 'routing' do
    describe 'with required campaign' do
      it 'routes to #new' do
        get('/campaigns/1/donations/new').should route_to('donations#new', campaign_id: '1')
      end

      it 'routes to #create' do
        post('/campaigns/1/donations').should route_to('donations#create', campaign_id: '1')
      end
    end

    describe 'not routed' do
      it 'does not route to #index' do
        get('/donations').should_not route_to('donations#index')
      end

      it 'does not route to #show' do
        get('/donations/1').should_not route_to('donations#show', :id => '1')
      end

      it 'does not route to #edit' do
        get('/donations/1/edit').should_not route_to('donations#edit', :id => '1')
      end

      it 'does not route to #create without a campaign' do
        post('/donations').should_not route_to('donations#create')
      end

      it 'does not route to #update' do
        put('/donations/1').should_not route_to('donations#update', :id => '1')
      end

      it 'does not route to #destroy' do
        delete('/donations/1').should_not route_to('donations#destroy', :id => '1')
      end
    end

  end
end
