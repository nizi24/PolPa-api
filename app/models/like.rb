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
        unless likeable.user.setting.comment_like_notice
          return
        end
        notice.like_type = 'Comment'
        notice.time_report_id = time_report.id
        FcmRegister.new(likeable.user).create_message("あなたの投稿がいいねされました。", "@#{user.screen_name}さんがあなたのコメントにいいねしました。")
      elsif time_report = likeable
        unless likeable.user.setting.time_report_like_notice
          return
        end
        notice.like_type = 'TimeReport'
        notice.time_report_id = time_report.id
        FcmRegister.new(likeable.user).create_message("あなたの投稿がいいねされました。", "@#{user.screen_name}さんがあなたの学習記録にいいねしました。")
      end
      notice.save!
    end
  end
end
