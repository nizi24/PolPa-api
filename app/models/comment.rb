class Comment < ApplicationRecord
  include Likeable

  belongs_to :user
  belongs_to :time_report

  validates :content, presence: true, length: { maximum: 280 }
end
