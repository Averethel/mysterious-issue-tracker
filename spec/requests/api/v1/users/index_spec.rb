require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /api/v1/users' do
    let!(:user1) { FactoryGirl.create(:user) }
    let!(:user2) { FactoryGirl.create(:user) }
    let(:body) { JSON.parse(response.body) }

    before do
      get api_v1_users_path(page: { size: 1 })
    end

    context 'metadata' do
      let(:metadata) { body['meta'] }

      it 'includes total' do
        expect(metadata['total']).to eq(2)
      end

      it 'includes current_page' do
        expect(metadata['current_page']).to eq(1)
      end

      it 'includes on_page' do
        expect(metadata['on_page']).to eq(1)
      end

      it 'includes total_pages' do
        expect(metadata['total_pages']).to eq(2)
      end
    end

    context 'links' do
      let(:links) { body['links'] }

      it 'includes link to self' do
        expect(links['self'])
          .to eq(api_v1_users_url(page: { size: 1, number: 1 }))
      end

      it 'includes link to next' do
        expect(links['next'])
          .to eq(api_v1_users_url(page: { size: 1, number: 2 }))
      end

      it 'includes link to last' do
        expect(links['last'])
          .to eq(api_v1_users_url(page: { size: 1, number: 2 }))
      end
    end

    context 'data' do
      let(:data) { body['data'] }

      it 'has page sieze users' do
        expect(data.size).to eq(1)
      end

      context 'for single user' do
        let(:user_data) { data.first }
        let(:attributes) { user_data['attributes'] }

        it 'includes id' do
          expect(user_data['id']).to eq(user1.id.to_s)
        end

        it 'includes type' do
          expect(user_data['type']).to eq('users')
        end

        it 'includes user attributes' do
          expect(attributes['username']).to eq(user1.username)
          expect(attributes['name']).to eq(user1.name)
          expect(attributes['surname']).to eq(user1.surname)
          expect(attributes['role']).to eq(user1.role)
        end
      end
    end
  end
end
