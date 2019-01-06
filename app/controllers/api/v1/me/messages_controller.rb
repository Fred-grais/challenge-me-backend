module Api
  module V1
    module Me
      class MessagesController < Api::V1::MeController

        def create
          message = current_user.messages.build(message_params)

          result = if message.save
             message_json = message.as_json(for_front: true)
             ActionCable.server.broadcast(ConversationChannel.compute_name(message.conversation_id), {newMessage: message_json})
            {success: true, message: message_json}
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