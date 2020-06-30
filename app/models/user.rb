class User < ApplicationRecord
  has_many :time_reports, dependent: :destroy
end
