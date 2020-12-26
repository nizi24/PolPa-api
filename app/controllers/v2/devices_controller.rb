class V2::DevicesController < ApplicationController

  def create
    fcm_token = params[:token]
    unless Device.find_by(firebase_registration_token: fcm_token)
      device = Device.new(user_id: params[:user_id],
        firebase_registration_token: fcm_token)
      device.save!
      render json: device.to_json
    end
  end

end
