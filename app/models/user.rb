class User < ApplicationRecord
  with_options dependent: :destroy do |assoc|
    assoc.has_many :time_reports, -> { order(study_date: :desc) }
    assoc.has_many :experience_records
    assoc.has_many :comments
    assoc.has_many :likes
    assoc.has_many :weekly_targets
    assoc.has_many :weekly_target_experience_records
    assoc.has_one :experience
    assoc.has_many :action, class_name: 'Notice',
      foreign_key: 'action_user_id'
    assoc.has_many :notices, class_name: 'Notice',
      foreign_key: 'received_user_id'
  end

  scope :join_exp, -> { joins(:experience).select('users.*,
    experiences.experience_to_next, experiences.total_experience,
    experiences.level') }
  scope :includes_tags, -> { includes(time_reports:
    { time_report_tag_links: :tag }) }
  scope :left_joins_tags, -> { left_joins(time_reports:
    { time_report_tag_links: :tag }) }
  scope :main_tags, -> (id) { includes_tags.left_joins_tags
    .select('COUNT(time_report_tag_links.*) AS count, tags.name, users.id')
    .group('tags.name, users.id')
    .where('users.id = ?', id)
    .limit(5)
    .order('count DESC')
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
    weekly_targets.where('weekly_targets.start_date = ?', weekly_start)
  end

  def target_of_non_checked
    weekly_start = Time.current.beginning_of_week.since(4.hours)
    prev_weekly_target = weekly_targets.find_by('weekly_targets.start_date < ?
      AND checked = false', weekly_start)
    prev_weekly_target.check if prev_weekly_target
    prev_weekly_target
  end

  def notice
    notices = self.notices.includes(:action_user)
      .joins(:action_user)
      .select('notices.*, users.screen_name')
      .limit(30)
      .order('notices.created_at DESC')
  end

  def notice_nonchecked
    notices.where(checked: false)
  end
end
