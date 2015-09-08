require 'rails_helper'
RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'assigns all users as @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end
end