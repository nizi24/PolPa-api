class Relationship < ApplicationRecord
  include Noticeable

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  validates :follower_id, presence: true, uniqueness: { scope: :followed_id }
  validates :followed_id, presence: true

  def notice
    user = User.find(followed_id)
    if user.setting.follow_notice
      notice = notices.build(
        action_user_id: follower_id,
        received_user_id: followed_id
      )
      notice.save!
    end
  end
end
