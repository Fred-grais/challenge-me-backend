module Api
  module V1
    module Me
      class ConversationsController < Api::V1::MeController

        def index
          @conversations = current_user.conversations.includes(:messages)

          render json: @conversations.as_json(preview: true, for_front: true)
        end
        
        def show
          @conversations = current_user.conversations.includes(:messages).find(params[:id])

          render json: @conversations.as_json(for_front: true)
        end
      end
    end
  end
end