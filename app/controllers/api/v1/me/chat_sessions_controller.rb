module Api
  module V1
    module Me
      class ChatSessionsController < Api::V1::MeController

        def create
          if current_user.rocket_chat_details.present?
             render json: {
               rocket_chat_auth_token: RocketChatInterface.new.generate_auth_token_for_user(current_user.rocket_chat_details.rocketchat_id)
             }.convert_keys_to_camelcase
           else
             render json: {
               error: :rocket_chat_user_id_missing
             }, status: :unprocessable_entity
           end
        end
      end
    end
  end
end