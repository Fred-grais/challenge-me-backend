# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

      def find_verified_user
        _, token, client_id, uid, _ = Base64.decode64(request.query_parameters["auth"]).split(";")
        user = User.find_by(uid: uid)

        if  user.present? && user.valid_token?(token, client_id)
          user
        else
          reject_unauthorized_connection
        end
      end
  end
end
