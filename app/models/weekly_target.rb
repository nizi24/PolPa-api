class WeeklyTarget < ApplicationRecord
  belongs_to :user
  has_one :weekly_target_experience_record, dependent: :destroy

  validates_uniqueness_of :user_id, scope: [ :start_date, :end_date ]

  def experience_record
    weekly_target_experience_record
  end
end
