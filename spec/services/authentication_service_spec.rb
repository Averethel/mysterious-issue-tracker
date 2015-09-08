require 'rails_helper'

RSpec.describe AuthenticationService, type: :model do
  subject { described_class.new(username: 'test', password: 'test') }
  let!(:user) { FactoryGirl.create(:user, user_attributes) }

  describe '#authenticate!' do
    context 'with valid username' do
      context 'and valid password' do
        let(:user_attributes) do
          {
            username: 'test',
            password: 'test',
            password_confirmation: 'test'
          }
        end

        it 'returs user' do
          expect(subject.authenticate!).to eq(user)
        end
      end

      context 'and invalid password' do
        let(:user_attributes) do
          {
            username: 'test',
            password: 'other',
            password_confirmation: 'other'
          }
        end

        it 'raises AuthenticationError' do
          expect do
            subject.authenticate!
          end.to raise_error(AuthenticationService::AuthenticationError)
        end
      end
    end

    context 'with invalid username' do
      let(:user_attributes) do
        {
          username: 'other',
          password: 'test',
          password_confirmation: 'test'
        }
      end

      it 'raises AuthenticationError' do
        expect do
          subject.authenticate!
        end.to raise_error(AuthenticationService::AuthenticationError)
      end
    end
  end
end
