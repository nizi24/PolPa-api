class Block < ApplicationRecord

  belongs_to :blocker, class_name: 'User'
  belongs_to :blocked, class_name: 'User'
  validates :blocker_id, presence: true, uniqueness: { scope: :blocked_id }
  validates :blocker_id, presence: true

end
