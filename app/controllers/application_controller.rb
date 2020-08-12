class ApplicationController < ActionController::API
  include ErrorHandlers if Rails.env.production?
end
