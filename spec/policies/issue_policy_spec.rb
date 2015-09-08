require 'rails_helper'

describe IssuePolicy do
  subject { described_class.new(user, issue) }
  let(:issue) { FactoryGirl.create(:issue, creator: creator) }

  context 'with guest' do
    let(:user) { FactoryGirl.build(:guest) }
    let(:creator) { FactoryGirl.create(:user) }

    it { is_expected.to permit_action(:show) }

    it { is_expected.not_to permit_action(:create) }
    it { is_expected.not_to permit_action(:update) }
    it { is_expected.not_to permit_action(:destroy) }
  end

  context 'with user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:creator) { FactoryGirl.create(:user) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }

    context 'for not created issue' do
      it { is_expected.not_to permit_action(:update) }
      it { is_expected.not_to permit_action(:destroy) }
    end

    context 'for self created issue' do
      let(:creator) { user }

      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end
  end

  context 'with admin' do
    let(:user) { FactoryGirl.create(:admin) }
    let(:creator) { FactoryGirl.create(:user) }

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:create) }

    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
