require 'rails_helper'

RSpec.describe Api::V1::IssuesController, type: :controller do
  describe 'GET #index' do
    let!(:issue) { FactoryGirl.create(:issue, priority: 'major') }

    it 'assigns all issues as @issues' do
      get :index
      expect(assigns(:issues)).to eq([issue])
    end

    context 'filtering' do
      let!(:other_issue) { FactoryGirl.create(:issue, title: 'different', description: 'different', priority: 'minor') }

      context 'by id' do
        it 'includes only issues with matching id' do
          get :index, filters: { id: [issue.id] }
          expect(assigns(:issues)).to eq([issue])
        end
      end

      context 'by title' do
        it 'includes only issues with matching title' do
          get :index, filters: { title: issue.title }
          expect(assigns(:issues)).to eq([issue])
        end
      end

      context 'by description' do
        it 'includes only issues with matching description' do
          get :index, filters: { description: issue.description }
          expect(assigns(:issues)).to eq([issue])
        end
      end

      context 'by priority' do
        it 'includes only issues with matching priority' do
          get :index, filters: { priority: [issue.priority] }
          expect(assigns(:issues)).to eq([issue])
        end
      end

      context 'by status' do
        before do
          issue.fixed!
        end

        it 'includes only issues with matching status' do
          get :index, filters: { status: ['fixed'] }
          expect(assigns(:issues)).to eq([issue])
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:issue) { FactoryGirl.create(:issue) }

    it 'assigns the requested issue as @issue' do
      get :show, id: issue.to_param
      expect(assigns(:issue)).to eq(issue)
    end
  end

  describe 'PATCH #take' do
    let!(:issue) { FactoryGirl.create(:issue) }

    context 'when authorized' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(user)
      end

      it 'assigns the requested issue as @issue' do
        patch :take, id: issue.to_param
        expect(assigns(:issue)).to eq(issue)
      end

      it 'assigns current_user to issue' do
        expect do
          patch :take, id: issue.to_param
        end.to change{
          issue.reload.assignee
        }.to(user)
      end
    end

    context 'when not authorized' do
      it 'is not found' do
        patch :take, id: issue.to_param
        expect(response).to be_not_found
      end
    end
  end

  describe 'PATCH #free' do
    let!(:issue) { FactoryGirl.create(:issue, assignee: assignee) }
    let(:assignee) { FactoryGirl.create(:user) }

    context 'when authorized' do
      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user)
          .and_return(assignee)
      end

      it 'assigns the requested issue as @issue' do
        patch :free, id: issue.to_param
        expect(assigns(:issue)).to eq(issue)
      end

      it 'assigns current_user to issue' do
        expect do
          patch :free, id: issue.to_param
        end.to change{
          issue.reload.assignee
        }.to(nil)
      end
    end

    context 'when not authorized' do
      it 'is not found' do
        patch :free, id: issue.to_param
        expect(response).to be_not_found
      end
    end
  end

  describe 'PATCH #update' do
    let(:assignee) { FactoryGirl.create(:user) }
    let!(:issue) { FactoryGirl.create(:issue, assignee: assignee) }
    let(:invalid_attributes) do
      {
        title: ''
      }
    end
    let(:valid_attributes) do
      {
        title: 'No comments',
        assignee_id: issue.creator.id
      }
    end

    context 'when authorized' do
      let(:user) { issue.creator }

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

        it 'allows to change the assignee' do
          expect do
            patch :update, id: issue.id, issue: valid_attributes
          end.to change{
            Issue.find(issue.id).assignee
          }.to(user)
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

      context 'as assignee' do
        let(:valid_attributes) do
          {
            title: 'new title',
            description: 'new description',
            priority: 'major'
          }
        end

        before do
          allow_any_instance_of(ApplicationController)
            .to receive(:current_user)
            .and_return(assignee)
        end

        it 'allows to change status' do
          expect do
            patch :update, id: issue.id, issue: { status: 'in_progress' }
          end.to change{
            Issue.find(issue.id).status
          }.to('in_progress')
        end

        it 'prevents from changing other attributes' do
          expect do
            patch :update, id: issue.id, issue: valid_attributes
          end.not_to change{
            Issue.find(issue.id).attributes
          }
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
          priority: 'critical',
          assignee_id: user.id
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

      it 'allows to set assignee' do
        post :create, issue: valid_attributes
        expect(assigns(:issue).assignee).to eq(user)
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
