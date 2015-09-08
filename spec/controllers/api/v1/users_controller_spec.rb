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
        expect do
          post :create, user: valid_attributes
        end.to change(User, :count).by(1)
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
          username: ''
        }
      end

      it 'assigns a newly created but unsaved user as @user' do
        post :create, user: invalid_attributes
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { FactoryGirl.create(:user) }

    context 'with valid params' do
      let(:valid_attributes) do
        {
          username: 'changed_username'
        }
      end

      it 'changes the user' do
        expect do
          patch :update, id: user.to_param, user: valid_attributes
        end.to change{
          User.find(user.id).username
        }.to 'changed_username'
      end

      it 'assigns the requested user as @user' do
        put :update, id: user.to_param, user: valid_attributes
        expect(assigns(:user)).to eq(user)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          password: ''
        }
      end

      it 'assigns the user as @user' do
        put :update, id: user.to_param, user: invalid_attributes
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'destroys the requested user' do
      expect do
        delete :destroy, id: user.to_param
      end.to change(User, :count).by(-1)
    end
  end
end
