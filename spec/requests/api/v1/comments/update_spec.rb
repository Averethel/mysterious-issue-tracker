require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  describe 'PATCH /api/v1/comments/1' do
    let(:comment) { FactoryGirl.create(:comment) }
    let(:body) { JSON.parse(response.body) }

    before do
      patch api_v1_comment_path(comment), params
    end

    context 'with valid params' do
      let(:params) do
        {
          comment: {
            body: 'No comments'
          }
        }
      end

      context 'data' do
        let(:data) { body['data'] }
        let(:attributes) { data['attributes'] }

        it 'includes id' do
          expect(data['id']).to eq(comment.id.to_s)
        end

        it 'includes type' do
          expect(data['type']).to eq('comments')
        end

        it 'includes comment attributes' do
          expect(attributes['body']).to eq('No comments')
        end
      end
    end

    context 'with invalid params:' do
      context 'missing comment param' do
        let(:params) { {} }
        let(:error) { body['errors'].first }

        it 'is unprocessable entity' do
          expect(response.status).to eq(422)
          expect(error['status']).to eq('422')
        end

        it 'resurns error message' do
          expect(error['title']).to eq('Invalid JSON submitted')
          expect(error['detail']).to eq('param is missing or the value is empty: comment')
        end
      end

      context 'validation errors' do
        let(:params) { { comment: { body: '' } } }
        let(:errors) { body['errors'] }

        it 'is unprocessable entity' do
          expect(response.status).to eq(422)
        end

        it 'resurns errors' do
          errors.each do |error|
            expect(error['status']).to eq('422')
            expect(['Invalid body']).to include(error['title'])
            expect(['can\'t be blank']).to include(error['detail'])
          end
        end
      end
    end
  end
end
