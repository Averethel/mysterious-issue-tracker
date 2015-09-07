require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  describe 'GET /api/v1/issues' do
    let!(:issue1) { FactoryGirl.create(:issue) }
    let!(:issue2) { FactoryGirl.create(:issue) }
    let(:body) { JSON.parse(response.body) }

    before do
      get api_v1_issues_path({page: {size: 1}})
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
        expect(links['self']).
          to eq(api_v1_issues_url({
            page: {size: 1, number: 1}
          }))
      end

      it 'includes link to next' do
        expect(links['next']).
          to eq(api_v1_issues_url({
            page: {size: 1, number: 2}
          }))
      end


      it 'includes link to last' do
        expect(links['last']).
          to eq(api_v1_issues_url({
            page: {size: 1, number: 2}
          }))
      end
    end

    context 'data' do
      let(:data) { body['data'] }

      it 'has page sieze issues' do
        expect(data.size).to eq(1)
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
