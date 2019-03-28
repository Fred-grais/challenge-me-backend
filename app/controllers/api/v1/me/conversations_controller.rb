# frozen_string_literal: true

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

        def create
          filtered_params = conversation_params

          @conversation = current_user.conversations.create(recipients: filtered_params[:recipients])
          if @conversation.persisted?
            current_user.messages.create!(conversation: @conversation, message: filtered_params[:message])
            render json: {
                success: true,
                preview: @conversation.as_json(preview: true, for_front: true),
                full: @conversation.as_json(for_front: true)
            }
          else
            render json: {
                success: false,
                errors: @conversation.errors.messages.keys
            }, status: :unprocessable_entity
          end
        end

        private

          def conversation_params
            params.require(:conversation).permit(:message, recipients: [])
          end
      end
    end
  end
end
