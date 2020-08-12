class ExperienceSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :total_experience, :level,
    :experience_to_next
end
