class Contact < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, allow_blank: true,  length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true
  validates :message, presence: true
end
