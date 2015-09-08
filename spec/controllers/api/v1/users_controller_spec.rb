require 'rails_helper'
RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'assigns all users as @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end
  end

  describe 'GET #show' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'assigns the requested user as @user' do
      get :show, id: user.to_param
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) do
        {
          username: 'test',
          password: 'test',
          password_confirmation: 'test'
        }
      end

      it 'creates a new User' do
        expect {
          post :create, user: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'assigns a newly created user as @user' do
        post :create, user: valid_attributes
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          username: '',
        }
      end

      it 'assigns a newly created but unsaved user as @user' do
        post :create, user: invalid_attributes
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end
end
