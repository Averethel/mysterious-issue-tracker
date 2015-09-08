require 'rails_helper'

RSpec.describe UserFilterService, type: :model do
  subject { described_class.new(filters).filter(User.all) }
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user, username: 'other') }

  context '#filter' do
    context 'by id' do
      let(:filters) do
        {
          id: [user1.id]
        }
      end

      it 'includes only issues with matching id' do
        expect(subject).to eq([user1])
      end
    end

    context 'by username' do
      let(:filters) do
        { username: user1.username }
      end

      it 'includes only issues with matching username' do
        expect(subject).to eq([user1])
      end
    end
  end
end
