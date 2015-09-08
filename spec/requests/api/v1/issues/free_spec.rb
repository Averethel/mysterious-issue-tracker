require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  describe 'GET /api/v1/issues/1' do
    let!(:issue) { FactoryGirl.create(:issue, assignee: user) }
    let(:body) { JSON.parse(response.body) }
    let!(:user) { FactoryGirl.create(:user, username: 'test', password: 'test') }

    before do
      env = { 'HTTP_AUTHORIZATION': ActionController::HttpAuthentication::Basic.encode_credentials('test', 'test') }
      patch free_api_v1_issue_path(issue), {}, env
    end

    context 'data' do
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

      context 'relationships' do
        let(:relationships) { data['relationships'] }

        context 'assignee' do
          let(:assignee) { relationships['assignee']['data'] }

          it 'is empty' do
            expect(assignee).to be_nil
          end
        end
      end
    end
  end
end
