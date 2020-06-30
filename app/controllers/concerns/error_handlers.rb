module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  end

  private def rescue404
    render json: { error: '404 not found' }, status: 404
  end
end
