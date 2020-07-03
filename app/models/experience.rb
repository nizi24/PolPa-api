class Experience < ApplicationRecord
  alias_attribute :total, :total_experience
  alias_attribute :to_next, :experience_to_next

  belongs_to :user
end
