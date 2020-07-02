class ExperienceRecord < ApplicationRecord
  belongs_to :user
  belongs_to :time_report
end
