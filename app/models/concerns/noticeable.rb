module Noticeable
  extend ActiveSupport::Concern

  included do
    has_many :notices, as: :noticeable, dependent: :destroy
  end

  def notice
    raise NotImplementedError
  end
end
