require 'rails_helper'

RSpec.describe Api::V1::IssuesController, type: :controller do
  describe 'GET #index' do
    let!(:issue){ FactoryGirl.create(:issue) }

    it 'assigns all issues as @issues' do
      get :index
      expect(assigns(:issues)).to eq([issue])
    end
  end
end
