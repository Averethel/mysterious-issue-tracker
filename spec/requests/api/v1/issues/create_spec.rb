require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  describe 'POST /api/v1/issues' do
    let!(:user) { FactoryGirl.create(:user, username: 'test', password: 'test') }
    let(:body) { JSON.parse(response.body) }

    before do
      env = { 'HTTP_AUTHORIZATION': ActionController::HttpAuthentication::Basic.encode_credentials('test', 'test') }
      post api_v1_issues_path, params, env
    end

    context 'with valid params' do
      let(:params) do
        {
          issue: {
            title: 'No comments',
            description: 'I want to comment issues',
            priority: 'critical'
          }
        }
      end

      context 'data' do
        let(:issue) { Issue.last }
        let(:data) { body['data'] }
        let(:attributes) { data['attributes'] }

        it 'includes id' do
          expect(data['id']).to eq(issue.id.to_s)
        end

        it 'includes type' do
          expect(data['type']).to eq('issues')
        end

        it 'includes issue attributes' do
          expect(attributes['title']).to eq(issue.title)
          expect(attributes['description']).to eq(issue.description)
          expect(attributes['priority']).to eq(issue.priority)
          expect(attributes['status']).to eq(issue.status)
        end
      end
    end

    context 'with invalid params:' do
      context 'missing issue param' do
        let(:params) { {} }
        let(:error) { body['errors'].first }

        it 'is unprocessable entity' do
          expect(response.status).to eq(422)
          expect(error['status']).to eq('422')
        end

        it 'resurns error message' do
          expect(error['title']).to eq('Invalid JSON submitted')
          expect(error['detail']).to eq('param is missing or the value is empty: issue')
        end
      end

      context 'wrong priority' do
        let(:params) do
          {
            issue: {
              title: 'No comments',
              description: 'I want to comment issues',
              priority: 'invalid'
            }
          }
        end
        let(:error) { body['errors'].first }

        it 'is unprocessable entity' do
          expect(response.status).to eq(422)
          expect(error['status']).to eq('422')
        end

        it 'resurns error message' do
          expect(error['title']).to eq('Invalid JSON submitted')
          expect(error['detail']).to eq('\'invalid\' is not a valid priority')
        end
      end

      context 'validation errors' do
        let(:params) { { issue: { priority: 'critical' } } }
        let(:errors) { body['errors'] }

        it 'is unprocessable entity' do
          expect(response.status).to eq(422)
        end

        it 'resurns errors' do
          errors.each do |error|
            expect(error['status']).to eq('422')
            expect(['Invalid title', 'Invalid description']).to include(error['title'])
            expect(['can\'t be blank']).to include(error['detail'])
          end
        end
      end
    end
  end
end
