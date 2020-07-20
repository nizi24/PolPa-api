class Like < ApplicationRecord
  include Noticeable

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates_uniqueness_of :user_id, scope: [:likeable_type, :likeable_id]

  def notice
    if user.id != likeable.user.id
      notice = notices.build(
        action_user_id: user.id,
        received_user_id: likeable.user.id
      )
      if time_report = likeable.try(:time_report)
        notice.like_type = 'Comment'
        notice.time_report_id = time_report.id
      elsif time_report = likeable
        notice.like_type = 'TimeReport'
        notice.time_report_id = time_report.id
      end
      notice.save!
    end
  end
end
