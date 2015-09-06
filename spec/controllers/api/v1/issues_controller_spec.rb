require 'rails_helper'

RSpec.describe Api::V1::IssuesController, type: :controller do
  describe 'GET #index' do
    let!(:issue){ FactoryGirl.create(:issue) }

    it 'assigns all issues as @issues' do
      get :index
      expect(assigns(:issues)).to eq([issue])
    end
  end

  describe 'GET #show' do
    let!(:issue){ FactoryGirl.create(:issue) }

    it 'assigns the requested issue as @issue' do
      get :show, {id: issue.to_param}
      expect(assigns(:issue)).to eq(issue)
    end
  end

  describe 'PATCH #update' do
    let!(:issue){ FactoryGirl.create(:issue) }

    context 'with valid params' do
      let(:valid_attributes) {{
        title: 'No comments'
      }}

      it 'changes the Issue' do
        expect {
          patch :update, {id: issue.id, issue: valid_attributes};
        }.to change{
          Issue.find(issue.id).title
        }.to('No comments')
      end

      it 'assigns a newly created issue as @issue' do
        patch :update, {id: issue.id, issue: valid_attributes}
        expect(assigns(:issue)).to be_a(Issue)
        expect(assigns(:issue)).to be_persisted
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) {{
        title: ''
      }}

      it 'assigns an issue as @issue' do
        patch :update, {id: issue.id, issue: invalid_attributes}
        expect(assigns(:issue)).to be_a(Issue)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) {{
        title: 'No comments',
        description: 'I want to comment issues',
        priority: 'critical'
      }}

      it 'creates a new Issue' do
        expect {
          post :create, {issue: valid_attributes}
        }.to change(Issue, :count).by(1)
      end

      it 'assigns a newly created issue as @issue' do
        post :create, {issue: valid_attributes}
        expect(assigns(:issue)).to be_a(Issue)
        expect(assigns(:issue)).to be_persisted
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) {{
        title: 'No comments',
        description: 'I want to comment issues'
      }}

      it 'assigns a newly created but unsaved issue as @issue' do
        post :create, {issue: invalid_attributes}
        expect(assigns(:issue)).to be_a_new(Issue)
      end
    end
  end
end
