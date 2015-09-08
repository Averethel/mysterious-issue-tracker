require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:issues) }
  it { is_expected.to have_many(:comments) }

  it { is_expected.to have_secure_password }
  it { is_expected.to define_enum_for(:role) }

  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }

  subject { FactoryGirl.build(:user) }

  context '#role' do
    it 'defaults to guest on new record' do
      expect(subject.role).to eq(:guest)
    end

    it 'defaults to user on persisted record' do
      subject.save!
      subject.reload
      expect(subject.role).to eq('user')
    end
  end
end
