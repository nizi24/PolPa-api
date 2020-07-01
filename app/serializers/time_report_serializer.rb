class TimeReportSerializer < ActiveModel::Serializer
  attributes :study_time, :memo, :created_at
end
