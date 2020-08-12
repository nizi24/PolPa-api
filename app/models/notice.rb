class Notice < ApplicationRecord
  belongs_to :received_user, class_name: 'User'
  belongs_to :action_user, class_name: 'User'
  belongs_to :noticeable, polymorphic: true, optional: true
  belongs_to :time_report, optional: true

  validates :action_user_id,
    uniqueness: { scope:
      [:received_user_id, :noticeable_id, :noticeable_type]
    }
end
