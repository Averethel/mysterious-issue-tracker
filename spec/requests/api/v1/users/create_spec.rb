require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /api/v1/users' do
    let(:body) { JSON.parse(response.body) }

    before do
      post api_v1_users_path, params
    end

    context 'with valid params' do
      let(:params) do
        {
          user: {
            username: 'test',
            password: 'test',
            password_confirmation: 'test',
            name: 'Tester',
            surname: 'Testy'
          }
        }
      end

      context 'data' do
        let(:user) { User.last }
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
        context 'password_confirmation mismatch' do
          let(:params) { { user: { username: 'test', password: 'foo', password_confirmation: 'bar' } } }
          let(:errors) { body['errors'] }

          it 'is unprocessable entity' do
            expect(response.status).to eq(422)
          end

          it 'resurns errors' do
            errors.each do |error|
              expect(error['status']).to eq('422')
              expect(['Invalid password_confirmation']).to include(error['title'])
              expect(['doesn\'t match Password']).to include(error['detail'])
            end
          end
        end

        context 'missing password_confirmation' do
          context 'password_confirmation mismatch' do
          let(:params) { { user: { username: 'test', password: 'foo' } } }
          let(:errors) { body['errors'] }

          it 'is unprocessable entity' do
            expect(response.status).to eq(422)
          end

          it 'resurns errors' do
            errors.each do |error|
              expect(error['status']).to eq('422')
              expect(['Invalid password_confirmation']).to include(error['title'])
              expect(['can\'t be blank']).to include(error['detail'])
            end
          end
        end
        end
      end
    end
  end
end
