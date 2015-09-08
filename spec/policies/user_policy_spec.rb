require 'rails_helper'

RSpec.describe UserPolicy do
  subject { described_class.new(user, other) }
  let(:other) { FactoryGirl.create(:user) }

  context 'with guest' do
    let(:user) { FactoryGirl.build(:guest) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }

    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context 'with user' do
    let(:user) { FactoryGirl.build(:user) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }

    context 'for other user' do
      it { is_expected.not_to permit_action(:update) }
      it { is_expected.not_to permit_action(:destroy) }
    end

    context 'for self' do
      let(:other) { user }

      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end
  end

  context 'with admin' do
    let(:user) { FactoryGirl.build(:admin) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }

    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
