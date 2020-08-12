class ExperienceRecord < ApplicationRecord
  belongs_to :user
  belongs_to :time_report

  validates :experience_point, presence: true,
    numericality: { only_integer: true }
end
