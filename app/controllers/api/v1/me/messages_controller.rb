module Api
  module V1
    module Me
      class MessagesController < Api::V1::MeController

        def create
          message = current_user.messages.build(message_params)

          result = if message.save
            {success: true, message: message.as_json(for_front: true)}
          else
            {success: false, errors: message.errors.full_messages}
          end

          render json: result
        end

        private

        def message_params
          params.require(:message).permit(:conversation_id, :message)
        end
      end
    end
  end
end