require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'PATCH /api/v1/users/1' do
    let(:user) { FactoryGirl.create(:user) }
    let(:body) { JSON.parse(response.body) }

    before do
      patch api_v1_user_path(user), params
    end

    context 'with valid params' do
      let(:params) do
        {
          user: {
            username: 'changed_username'
          }
        }
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
          expect(attributes['username']).to eq('changed_username')
          expect(attributes['name']).to eq(user.name)
          expect(attributes['surname']).to eq(user.surname)
        end
      end
    end

    context 'with invalid params:' do
      context 'missing user param' do
        let(:params) { {} }
        let(:error) { body['errors'].first }

        it 'is unprocessable entity' do
          expect(response.status).to eq(422)
          expect(error['status']).to eq('422')
        end

        it 'resurns error message' do
          expect(error['title']).to eq('Invalid JSON submitted')
          expect(error['detail']).to eq('param is missing or the value is empty: user')
        end
      end

      context 'validation errors' do
        let(:params) { { user: { username: '', password: '' } } }
        let(:errors) { body['errors'] }

        it 'is unprocessable entity' do
          expect(response.status).to eq(422)
        end

        it 'resurns errors' do
          errors.each do |error|
            expect(error['status']).to eq('422')
            expect(['Invalid username', 'Invalid password']).to include(error['title'])
            expect(['can\'t be blank']).to include(error['detail'])
          end
        end
      end
    end
  end
end
