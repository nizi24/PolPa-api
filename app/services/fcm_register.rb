class FcmRegister

  def initialize(received_user)
    @received_user = received_user
  end

  def create_message(title, body)
    # TODO: 環境変数に変更する
    server_key = ENV['FirebaseMessageServerKey']
    fcm = FCM.new(server_key)
    options = {
      "notification": {
                "title": title,
                "body": body,
                "badge": @received_user.notice_nonchecked.count
          }
      }
    registration_ids = @received_user.devices.map(&:firebase_registration_token)
    response = fcm.send(registration_ids, options)
    # byebug
  end

end
