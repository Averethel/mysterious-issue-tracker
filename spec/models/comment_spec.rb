require 'rails_helper'

RSpec.describe Comment do
  let(:attributes) { {} }
  subject { described_class.new(attributes) }

  it { is_expected.to belong_to(:issue) }

  it { is_expected.to validate_presence_of(:body) }
end
