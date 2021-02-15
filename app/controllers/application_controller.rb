class ApplicationController < ActionController::API
  include ErrorHandlers if Rails.env.production?

  private
    def authorize
      access_token = extract_access_token
      @current_user_firebase_uid = access_token.first['sub']
    end

    def current_user
      return unless @current_user_firebase_uid
      @current_user ||= User.find_by(uuid: @current_user_firebase_uid)
    end

    def extract_access_token
      authenticate_with_http_token do |token, _|
        Firebase::Auth::IDTokenKeeper::IDToken.new(token).verified_id_token
      end
    end
end
