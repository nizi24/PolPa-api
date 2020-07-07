class TimeReportTagLink < ApplicationRecord
  belongs_to :time_report
  belongs_to :tag
end
