require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /api/v1/users/me' do
    let!(:user) { FactoryGirl.create(:user, username: 'test', password: 'test') }
    let(:body) { JSON.parse(response.body) }

    before do
      env = { 'HTTP_AUTHORIZATION': ActionController::HttpAuthentication::Basic.encode_credentials('test', 'test') }
      get me_api_v1_users_path, {}, env
    end

    context 'data' do
      let(:data) { body['data'] }
      let(:attributes) { data['attributes'] }

      it 'includes id' do
        expect(data['id']).to eq(user.id.to_s)
      end

      it 'includes type' do
        expect(data['type']).to eq('users')
      end

      it 'includes user attributes' do
        expect(attributes['username']).to eq(user.username)
        expect(attributes['name']).to eq(user.name)
        expect(attributes['surname']).to eq(user.surname)
        expect(attributes['role']).to eq(user.role)
      end
    end
  end
end
