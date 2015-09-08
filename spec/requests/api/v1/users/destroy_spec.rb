require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'DELETE /api/v1/users/1' do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      delete api_v1_user_path(user)
    end

    it 'has status 204' do
      expect(response.status).to eq(204)
    end
  end
end
