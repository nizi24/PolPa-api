class User < ApplicationRecord
  has_many :time_reports, dependent: :destroy
  has_many :experience_records, dependent: :destroy
end
