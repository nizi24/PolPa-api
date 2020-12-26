class Device < ApplicationRecord
  belongs_to :user

  validates :firebase_registration_token, uniqueness: true
end
