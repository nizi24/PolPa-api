class Experience < ApplicationRecord
  alias_attribute :total, :total_experience
  alias_attribute :to_next, :experience_to_next

  belongs_to :user

  validates :level, presence: true, numericality: { only_integer: true }
  validates :total, presence: true, numericality: { only_integer: true }
  validates :to_next, presence: true, numericality: { only_integer: true }

  def self.total_experience_rank
    experiences = Experience.order(total_experience: :desc).limit(10)
    experiences.map(&:id)
  end
end
