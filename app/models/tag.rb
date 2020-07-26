class Tag < ApplicationRecord
  has_many :time_report_tag_links, dependent: :destroy
  has_many :time_reports, through: :time_report_tag_links
  has_many :user_tag_relationships, dependent: :destroy
  has_many :users, through: :user_tag_relationships

  validates :name, presence: true, length: { maximum: 50 }

  def links
    time_report_tag_links
  end

  def follower_count
    user_tag_relationships.count
  end

  def time_report_count
    time_report_tag_links.count
  end
end
