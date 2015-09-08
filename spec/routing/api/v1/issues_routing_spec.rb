require 'rails_helper'

RSpec.describe Api::V1::IssuesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/issues')
        .to route_to('api/v1/issues#index', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/issues/1')
        .to route_to('api/v1/issues#show', id: '1', format: :json)
    end

    it 'routes to #take' do
      expect(patch: '/api/v1/issues/1/take')
        .to route_to('api/v1/issues#take', id: '1', format: :json)
    end

    it 'routes to #take via PUT' do
      expect(put: '/api/v1/issues/1/take')
        .to route_to('api/v1/issues#take', id: '1', format: :json)
    end

    it 'routes to #free' do
      expect(patch: '/api/v1/issues/1/free')
        .to route_to('api/v1/issues#free', id: '1', format: :json)
    end

    it 'routes to #free via PUT' do
      expect(put: '/api/v1/issues/1/free')
        .to route_to('api/v1/issues#free', id: '1', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/issues')
        .to route_to('api/v1/issues#create', format: :json)
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/issues/1')
        .to route_to('api/v1/issues#update', id: '1', format: :json)
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/issues/1')
        .to route_to('api/v1/issues#update', id: '1', format: :json)
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/issues/1')
        .to route_to('api/v1/issues#destroy', id: '1', format: :json)
    end
  end
end
