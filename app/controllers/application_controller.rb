class ApplicationController < ActionController::API
  include ErrorHandlers if Rails.env.production?
  include ActionController::HttpAuthentication::Token::ControllerMethods

  private
    def authorize
      access_token = extract_access_token
      @current_user_firebase_uid = access_token.first['sub']
    end

    def current_user
      return unless @current_user_firebase_uid
      @current_user ||= User.find_by(uid: @current_user_firebase_uid)
    end

    def extract_access_token
      # byebug
      Firebase::Auth::IDTokenKeeper::IDToken.new(token_from_request_headers).verified_id_token
    end

    def token_from_request_headers
      request.headers['Authorization']&.split&.last
    end
end
