class User < ApplicationRecord
  has_many :time_reports, dependent: :destroy
  has_many :experience_records, dependent: :destroy
  has_one :experience, dependent: :destroy

  scope :join_exp, -> { joins(:experience).select('users.*,
    experiences.experience_to_next, experiences.total_experience,
    experiences.level') }
end
