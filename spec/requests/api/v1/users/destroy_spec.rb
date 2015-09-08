require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'DELETE /api/v1/users/1' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:admin) {FactoryGirl.create(:admin, username: 'test', password: 'test') }

    before do
      env = { 'HTTP_AUTHORIZATION': ActionController::HttpAuthentication::Basic.encode_credentials('test', 'test') }
      delete api_v1_user_path(user), {}, env
    end

    it 'has status 204' do
      expect(response.status).to eq(204)
    end
  end
end
