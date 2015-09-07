require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'GET /api/v1/comments/1' do
    let!(:comment) { FactoryGirl.create(:comment) }
    let(:body) { JSON.parse(response.body) }

    before do
      get api_v1_comment_path(comment)
    end

    context 'data' do
      let(:data) { body['data'] }
      let(:attributes) { data['attributes'] }

      it 'includes id' do
        expect(data['id']).to eq(comment.id.to_s)
      end

      it 'includes type' do
        expect(data['type']).to eq('comments')
      end

      it 'includes comment attributes' do
        expect(attributes['body']).to eq(comment.body)
      end
    end
  end
end
