class Comment < ApplicationRecord
  include Likeable
  include Noticeable

  belongs_to :user
  belongs_to :time_report

  validates :content, presence: true, length: { maximum: 280 }

  def notice
    if user.id != time_report.user.id && time_report.user.setting.comment_notice
      notice = notices.build(
        action_user_id: user.id,
        received_user_id: time_report.user.id,
        time_report_id: time_report.id
      )
      notice.save!
    end
  end
end
