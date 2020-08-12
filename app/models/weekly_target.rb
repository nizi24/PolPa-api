class WeeklyTarget < ApplicationRecord
  belongs_to :user
  has_one :weekly_target_experience_record, dependent: :destroy

  validates :user_id, uniqueness: { scope: [:start_date, :end_date] }

  def experience_record
    weekly_target_experience_record
  end

  def check
    self.checked = true
    if progress >= target_time
      self.achieve = true
      WeeklyTargetProcessor.new(user).experience_record(self)
    end
    save
  end
end
