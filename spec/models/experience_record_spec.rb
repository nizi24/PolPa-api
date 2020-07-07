require 'rails_helper'

RSpec.describe ExperienceRecord, type: :model do
  let(:user) { create(:user) }
  let(:time_report) { create(:time_report) }
  subject(:experience_record) { create(:experience_record, user: user,
    time_report: time_report) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:experience_point) }
  it { is_expected.to validate_numericality_of(:experience_point) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:time_report) }
end
