class TimeReport < ApplicationRecord
  belongs_to :user
  has_one :experience_record, dependent: :destroy

  scope :join_exp, -> { joins(:experience_record)
    .select('time_reports.*, experience_records.*') }
  scope :newest, -> { order(created_at: :desc) }

  validates :study_time, presence: true
end
