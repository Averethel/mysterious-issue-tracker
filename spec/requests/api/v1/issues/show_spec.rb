require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  describe 'GET /api/v1/issues/1' do
    let!(:issue) { FactoryGirl.create(:issue) }
    let(:body) { JSON.parse(response.body) }

    before do
      get api_v1_issue_path(issue)
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
    end
  end
end
