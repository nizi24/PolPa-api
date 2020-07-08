class Tag < ApplicationRecord
  has_many :time_report_tag_links, dependent: :destroy
  has_many :time_reports, through: :time_report_tag_links

  validates :name, presence: true, length: { maximum: 50 }

  def links
    time_report_tag_links
  end
end
