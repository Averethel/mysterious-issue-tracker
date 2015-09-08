require 'rails_helper'

RSpec.describe IssueFilterService, type: :model do
  subject { described_class.new(filters).filter(Issue.all) }
  let!(:issue1) { FactoryGirl.create(:issue, priority: 'major') }
  let!(:issue2) { FactoryGirl.create(:issue, title: 'different', description: 'different', priority: 'minor') }

  context '#filter' do
    context 'by id' do
      let(:filters) do
        {
          id: [issue1.id]
        }
      end

      it 'includes only issues with matching id' do
        expect(subject).to eq([issue1])
      end
    end

    context 'by title' do
      let(:filters) do
        { title: issue1.title }
      end

      it 'includes only issues with matching title' do
        expect(subject).to eq([issue1])
      end
    end

    context 'by description' do
      let(:filters) do
        { description: issue1.description }
      end

      it 'includes only issues with matching description' do
        expect(subject).to eq([issue1])
      end
    end

    context 'by priority' do
      let(:filters) do
        { priority: [issue1.priority] }
      end

      it 'includes only issues with matching priority' do
        expect(subject).to eq([issue1])
      end
    end

    context 'by status' do
      before do
        issue1.fixed!
      end

      let(:filters) do
        { status: ['fixed'] }
      end

      it 'includes only issues with matching status' do
        expect(subject).to eq([issue1])
      end
    end
  end
end
