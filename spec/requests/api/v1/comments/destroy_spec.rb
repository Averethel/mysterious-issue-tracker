require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'DELETE /api/v1/comments/1' do
    let!(:comment) { FactoryGirl.create(:comment) }

    before do
      delete api_v1_comment_path(comment)
    end

    it 'has status 204' do
      expect(response.status).to eq(204)
    end
  end
end
