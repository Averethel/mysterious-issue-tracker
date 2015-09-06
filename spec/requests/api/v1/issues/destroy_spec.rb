require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  describe 'DELETE /api/v1/issues/1' do
    let!(:issue) { FactoryGirl.create(:issue) }

    before do
      delete api_v1_issue_path(issue)
    end

    it 'has status 204' do
      expect(response.status).to eq(204)
    end
  end
end
