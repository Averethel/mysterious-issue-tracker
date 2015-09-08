require 'rails_helper'

RSpec.describe Api::V1::IssuesController, type: :controller do
  describe 'GET #index' do
    let!(:issue) { FactoryGirl.create(:issue) }

    it 'assigns all issues as @issues' do
      get :index
      expect(assigns(:issues)).to eq([issue])
    end
  end

  describe 'GET #show' do
    let!(:issue) { FactoryGirl.create(:issue) }

    it 'assigns the requested issue as @issue' do
      get :show, id: issue.to_param
      expect(assigns(:issue)).to eq(issue)
    end
  end

  describe 'PATCH #update' do
    let!(:issue) { FactoryGirl.create(:issue) }
    let(:invalid_attributes) do
      {
        title: ''
      }
    end
    let(:valid_attributes) do
      {
        title: 'No comments'
      }
    end


    context 'when authorized' do
      let(:user){ issue.creator }

      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(FactoryGirl.create(:admin))
      end

      context 'with valid params' do
        it 'changes the Issue' do
          expect do
            patch :update, id: issue.id, issue: valid_attributes
          end.to change{
            Issue.find(issue.id).title
          }.to('No comments')
        end

        it 'assigns a requested issue as @issue' do
          patch :update, id: issue.id, issue: valid_attributes
          expect(assigns(:issue)).to be_a(Issue)
          expect(assigns(:issue)).to be_persisted
        end
      end

      context 'with invalid params' do
        it 'assigns an issue as @issue' do
          patch :update, id: issue.id, issue: invalid_attributes
          expect(assigns(:issue)).to be_a(Issue)
        end
      end
    end

    context 'when not authorized' do
      it 'is not found' do
        put :update, id: issue.id, issue: valid_attributes
        expect(response).to be_not_found
      end
    end
  end

  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)
    end

    context 'with valid params' do
      let(:valid_attributes) do
        {
          title: 'No comments',
          description: 'I want to comment issues',
          priority: 'critical'
        }
      end

      it 'creates a new Issue' do
        expect do
          post :create, issue: valid_attributes
        end.to change(Issue, :count).by(1)
      end

      it 'assigns a newly created issue as @issue' do
        post :create, issue: valid_attributes
        expect(assigns(:issue)).to be_a(Issue)
        expect(assigns(:issue)).to be_persisted
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          title: 'No comments',
          description: 'I want to comment issues'
        }
      end

      it 'assigns a newly created but unsaved issue as @issue' do
        post :create, issue: invalid_attributes
        expect(assigns(:issue)).to be_a_new(Issue)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:issue) { FactoryGirl.create(:issue) }

    context 'when authorized' do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(FactoryGirl.create(:admin))
      end

      it 'destroys the requested issue' do
        expect do
          delete :destroy, id: issue.to_param
        end.to change(Issue, :count).by(-1)
      end
    end

    context 'when not authorized' do
      it 'is not found' do
        delete :destroy, id: issue.to_param
        expect(response).to be_not_found
      end
    end
  end
end
