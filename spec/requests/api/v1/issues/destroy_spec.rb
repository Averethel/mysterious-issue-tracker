require 'rails_helper'

RSpec.describe 'Issues', type: :request do
  describe 'DELETE /api/v1/issues/1' do
    let!(:issue) { FactoryGirl.create(:issue) }
    let!(:admin) {FactoryGirl.create(:admin, username: 'test', password: 'test') }

    before do
      env = { 'HTTP_AUTHORIZATION': ActionController::HttpAuthentication::Basic.encode_credentials('test', 'test') }
      delete api_v1_issue_path(issue), {}, env
    end

    it 'has status 204' do
      expect(response.status).to eq(204)
    end
  end
end
