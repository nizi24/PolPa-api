class ExperienceRecordSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :experience_point, :time_report_id,
    :bonus_multiplier
end
