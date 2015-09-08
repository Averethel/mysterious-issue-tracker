require 'rails_helper'

RSpec.describe Issue do
  let(:attributes) { {} }
  subject { described_class.new(attributes) }

  it { is_expected.to have_many(:comments) }
  it { is_expected.to belong_to(:creator) }
  it { is_expected.to belong_to(:assignee) }

  it { is_expected.to define_enum_for(:status) }
  it { is_expected.to define_enum_for(:priority) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:priority) }
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to validate_presence_of(:creator) }

  describe '#status' do
    let(:attributes) { {} }

    it 'is open by default' do
      expect(subject.status).to eq('open')
    end

    context 'validations' do
      let(:attributes) do
        {
          status: nil,
          title: "There's a nil status",
          description: "Status 'nil' is valid",
          priority: 'major'
        }
      end

      it 'cannot be nil' do
        expect(subject.valid?).to be(false)
        expect(subject.errors.messages[:status]).to include('can\'t be blank')
      end

      context 'on create' do
        let(:attributes) do
          {
            status: 'in_progress',
            title: "There's a nil status",
            description: "Status 'nil' is valid",
            priority: 'minor'
          }
        end

        it 'must be open' do
          expect(subject.valid?).to be(false)
          expect(subject.errors.messages[:status]).to include('must be \'open\'')
        end
      end
    end
  end
end
