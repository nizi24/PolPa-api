class TimeReportSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :study_time, :memo, :created_at
end
