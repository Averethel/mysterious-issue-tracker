require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  describe 'GET #index' do
    let!(:issue) { FactoryGirl.create(:issue_with_comments, comment_count: 1) }
    let!(:comment) { FactoryGirl.create(:comment) }

    it 'assigns all issue comments as @comments' do
      get :index, issue_id: issue
      expect(assigns(:comments)).to eq(issue.comments)
    end
  end

  describe 'GET #show' do
    let!(:comment) { FactoryGirl.create(:comment) }

    it 'assigns the requested comment as @comment' do
      get :show, {id: comment.to_param}
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe 'PATCH #update' do
    let!(:comment) { FactoryGirl.create(:comment) }

    context 'with valid params' do
      let(:valid_attributes) do
        {
          body: '+1'
        }
      end

      it 'changes the Comment' do
        expect do
          patch :update, id: comment.id, comment: valid_attributes
        end.to change{
          Comment.find(comment.id).body
        }.to('+1')
      end

      it 'assigns a newly created comment as @comment' do
        patch :update, id: comment.id, comment: valid_attributes
        expect(assigns(:comment)).to be_a(Comment)
        expect(assigns(:comment)).to be_persisted
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          body: ''
        }
      end

      it 'assigns an comment as @comment' do
        patch :update, id: comment.id, comment: invalid_attributes
        expect(assigns(:comment)).to be_a(Comment)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { FactoryGirl.create(:comment) }

    it 'destroys the requested comment' do
      expect do
        delete :destroy, id: comment.to_param
      end.to change(Comment, :count).by(-1)
    end
  end
end
