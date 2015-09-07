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
end
