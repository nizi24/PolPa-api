require 'rails_helper'

RSpec.describe TimeReportTagLink, type: :model do
  subject(:time_report_tag_link) { create(:time_report_tag_link) }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:time_report) }
  it { is_expected.to belong_to(:tag) }
end
