class Notice < ApplicationRecord
  belongs_to :received_user, class_name: 'User'
  belongs_to :action_user,   class_name: 'User'
  belongs_to :noticeable, polymorphic: true
  belongs_to :time_report, optional: true
end
