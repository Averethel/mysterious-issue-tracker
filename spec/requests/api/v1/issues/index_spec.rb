require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  describe 'GET /api/v1/issues' do
    let!(:issue1) { FactoryGirl.create(:issue) }
    let!(:issue2) { FactoryGirl.create(:issue) }
    let(:body) { JSON.parse(response.body) }

    before do
      get api_v1_issues_path
    end

    context 'metadata' do
      let(:metadata) { body['meta'] }

      it 'includes total' do
        expect(metadata['total']).to eq(2)
      end
    end

    context 'data' do
      let(:data) { body['data'] }

      it 'includes all issues' do
        expect(data.size).to eq(2)
      end

      context 'for single issue' do
        let(:issue_data) { data.first }
        let(:attributes) { issue_data['attributes'] }

        it 'includes id' do
          expect(issue_data['id']).to eq(issue1.id.to_s)
        end

        it 'includes type' do
          expect(issue_data['type']).to eq('issues')
        end

        it 'includes issue attributes' do
          expect(attributes['title']).to eq(issue1.title)
          expect(attributes['description']).to eq(issue1.description)
          expect(attributes['priority']).to eq(issue1.priority)
          expect(attributes['status']).to eq(issue1.status)
        end
      end
    end
  end
end
