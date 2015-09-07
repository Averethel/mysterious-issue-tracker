require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'GET /api/v1/issues/1/comments' do
    let!(:issue) { FactoryGirl.create(:issue_with_comments, comment_count: 2) }
    let!(:comment) { FactoryGirl.create(:comment) }
    let(:body) { JSON.parse(response.body) }

    before do
      get api_v1_issue_comments_path(issue, page: {size: 1})
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
          to eq(api_v1_issue_comments_url(issue, {
            page: {size: 1, number: 1}
          }))
      end

      it 'includes link to next' do
        expect(links['next']).
          to eq(api_v1_issue_comments_url(issue, {
            page: {size: 1, number: 2}
          }))
      end


      it 'includes link to last' do
        expect(links['last']).
          to eq(api_v1_issue_comments_url(issue, {
            page: {size: 1, number: 2}
          }))
      end
    end

    context 'data' do
      let(:data) { body['data'] }

      it 'has page size comments' do
        expect(data.size).to eq(1)
      end

      context 'for single issue' do
        let(:issue_data) { data.first }
        let(:attributes) { issue_data['attributes'] }
        let(:comment) { issue.comments.last }

        it 'includes id' do
          expect(issue_data['id']).to eq(comment.id.to_s)
        end

        it 'includes type' do
          expect(issue_data['type']).to eq('comments')
        end

        it 'includes comment attributes' do
          expect(attributes['body']).to eq(comment.body)
        end
      end
    end
  end
end
