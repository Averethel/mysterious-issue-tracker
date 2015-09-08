require 'rails_helper'
RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET #index' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'assigns all users as @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end

    context 'filtering' do
      let!(:other_user) { FactoryGirl.create(:user, username: 'different') }

      context 'by id' do
        it 'includes only users with matching id' do
          get :index, filters: { id: [user.id] }
          expect(assigns(:users)).to eq([user])
        end
      end

      context 'by username' do
        it 'includes only users with matching id' do
          get :index, filters: { username: user.username }
          expect(assigns(:users)).to eq([user])
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'assigns the requested user as @user' do
      get :show, id: user.to_param
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'GET #me' do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)
    end

    it 'assigns the current_user as @user' do
      get :me
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) do
        {
          username: 'test',
          password: 'test',
          password_confirmation: 'test',
          role: 'admin'
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

      context 'as admin' do
        before do
          allow_any_instance_of(ApplicationController)
            .to receive(:current_user)
            .and_return(FactoryGirl.create(:admin))
        end

        it 'allows to assign role' do
          post :create, user: valid_attributes
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user)).to be_admin
        end
      end

      context 'as non admin' do
        it 'defaukts role to user' do
          post :create, user: valid_attributes
          expect(assigns(:user)).to be_user
        end
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
    let(:valid_attributes) do
      {
        username: 'changed_username'
      }
    end
    let(:invalid_attributes) do
      {
        password: ''
      }
    end

    context 'when authorized' do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(FactoryGirl.create(:admin))
      end

      context 'with valid params' do
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
        it 'assigns the user as @user' do
          put :update, id: user.to_param, user: invalid_attributes
          expect(assigns(:user)).to eq(user)
        end
      end
    end

    context 'when not authorized' do
      it 'is not found' do
        put :update, id: user.to_param, user: valid_attributes
        expect(response).to be_not_found
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { FactoryGirl.create(:user) }

    context 'when authorized' do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(FactoryGirl.create(:admin))
      end

      it 'destroys the requested user' do
        expect do
          delete :destroy, id: user.to_param
        end.to change(User, :count).by(-1)
      end
    end

    context 'when not authorized' do
      it 'is not found' do
        delete :destroy, id: user.to_param
        expect(response).to be_not_found
      end
    end
  end
end
