class WeeklyTarget < ApplicationRecord
  belongs_to :user

  validates_uniqueness_of :user_id, scope: [ :start_date, :end_date ]
end
