require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject(:comment) { create(:comment) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_length_of(:content) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:time_report) }
end
