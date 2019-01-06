class ConversationChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    stream_from ConversationChannel.compute_name(params[:conversation_id])
  end

  private

  def self.compute_name(conversation_id)
    "conversation_#{conversation_id}"
  end
end