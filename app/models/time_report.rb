class TimeReport < ApplicationRecord
  belongs_to :user
  has_one :experience_record, dependent: :destroy
  has_many :time_report_tag_links, dependent: :destroy
  has_many :tags, -> { order(:name) }, through: :time_report_tag_links

  scope :join_exp, -> { joins(:experience_record)
    .select('time_reports.*, experience_records.*') }
  scope :newest, -> { order(created_at: :desc) }

  validates :study_time, presence: true
  validates :memo, length: { maximum: 280 }
end
