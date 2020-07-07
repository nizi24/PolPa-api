require 'rails_helper'

RSpec.describe TimeReport, type: :model do
  let(:user) { create(:user) }
  subject(:time_report) { create(:time_report, user: user) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:study_time) }
  it { is_expected.to validate_length_of(:memo) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_one(:experience_record) }
end
