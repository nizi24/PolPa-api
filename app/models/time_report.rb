class TimeReport < ApplicationRecord
  belongs_to :user
  has_one :experience_record, dependent: :destroy
end
