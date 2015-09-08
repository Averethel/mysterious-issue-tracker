require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /api/v1/users/1' do
    let!(:user) { FactoryGirl.create(:user) }
    let(:body) { JSON.parse(response.body) }

    before do
      get api_v1_user_path(user)
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
      end
    end
  end
end
