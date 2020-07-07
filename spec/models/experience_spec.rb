require 'rails_helper'

RSpec.describe Experience, type: :model do
  let(:user) { create(:user) }
  subject(:experience) { create(:experience, user: user) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:level) }
  it { is_expected.to validate_numericality_of(:level) }
  it { is_expected.to validate_presence_of(:total) }
  it { is_expected.to validate_presence_of(:to_next) }
  it { is_expected.to belong_to(:user) }
end
