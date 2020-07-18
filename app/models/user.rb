class User < ApplicationRecord
  with_options dependent: :destroy do |assoc|
    assoc.has_many :time_reports, -> { order(study_date: :desc) }
    assoc.has_many :experience_records
    assoc.has_many :comments
    assoc.has_many :likes
    assoc.has_many :weekly_targets
    assoc.has_many :weekly_target_experience_records
    assoc.has_one :experience
  end

  scope :join_exp, -> { joins(:experience).select('users.*,
    experiences.experience_to_next, experiences.total_experience,
    experiences.level') }
  scope :includes_tags, -> { includes(time_reports:
    { time_report_tag_links: :tag }) }
  scope :left_joins_tags, -> { left_joins(time_reports:
    { time_report_tag_links: :tag }) }
  scope :main_tags, -> (id) { includes_tags.left_joins_tags
    .select('COUNT(time_report_tag_links.*), tags.name, users.id')
    .group('tags.name, users.id')
    .where('users.id = ?', id)
    .limit(5)
    .order('COUNT(time_report_tag_links.time_report_id) DESC')
  }
  scope :search_time_reports_in_tags, -> (user_id, tag) {
    includes_tags.left_joins_tags
    .select('time_reports.id')
    .where('users.id = ? AND tags.name LIKE ?', user_id, "%#{tag}%")
    .order('time_reports.study_date')
  }

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 255 },
    uniqueness:   { case_sensitive: false }
  validates :uid, presence: true
  VALID_SCREEN_NAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :screen_name, presence: true, length: { in: 5..15 },
    uniqueness:   { case_sensitive: false },
    format: { with: VALID_SCREEN_NAME_REGEX }

  def target_of_the_week
    weekly_start = Time.current.beginning_of_week.since(4.hours)
    weekly_targets.where('weekly_targets.created_at >= ?', weekly_start)
  end
end
