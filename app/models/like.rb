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
      setting = true
      if time_report = likeable.try(:time_report)
        notice.like_type = 'Comment'
        notice.time_report_id = time_report.id
        unless likeable.user.setting.comment_like_notice
          setting = false
        end
      elsif time_report = likeable
        notice.like_type = 'TimeReport'
        notice.time_report_id = time_report.id
        unless likeable.user.setting.time_report_like_notice
          setting = false
        end
      end
      notice.save! if setting
    end
  end
end
