class Message < ApplicationRecord

  include FrontDataGeneration

  validates_presence_of :conversation_id, :sender_id, :message
  validate :sender_is_a_conversation_recipient

  belongs_to :conversation
  belongs_to :sender, class_name: 'User'

  FULL_ATTRIBUTES = {
      attributes: [:sender_id, :message, :created_at],
  }

  private

  def sender_is_a_conversation_recipient
    if conversation.present?
      current_conversation_recipients = self.conversation.recipients
      sender_email = self.sender.email

      valid = current_conversation_recipients.include?(sender_email)
      unless valid
        self.errors.add(:not_recipient, "#{sender_email} is not a recipient of the conversation #{self.conversation_id}")
      end

      valid
    else
      false
    end
  end
end
