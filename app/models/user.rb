class User < ApplicationRecord
  has_many :time_reports, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :experience_records, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :experience, dependent: :destroy

  scope :join_exp, -> { joins(:experience).select('users.*,
    experiences.experience_to_next, experiences.total_experience,
    experiences.level') }

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 255 },
    uniqueness:   { case_sensitive: false }
  validates :uid, presence: true
  VALID_SCREEN_NAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :screen_name, presence: true, length: { in: 5..15 },
    uniqueness:   { case_sensitive: false },
    format: { with: VALID_SCREEN_NAME_REGEX }
end
