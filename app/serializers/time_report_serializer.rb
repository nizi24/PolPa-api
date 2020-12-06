class TimeReportSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :study_time, :study_date, :memo, :created_at
end
