class Conversation < ApplicationRecord

  include FrontDataGeneration

  validates_uniqueness_of :recipients

  before_validation :sort_recipients

  has_many :messages

  PREVIEW_ATTRIBUTES = {
      attributes: [:id],
      methods: [:expanded_recipients, :last_message_preview]
  }

  FULL_ATTRIBUTES = {
      attributes: [:id],
      methods: [:expanded_recipients, :displayed_messages]
  }

  def expanded_recipients
    User.select(:id, :email, :first_name, :last_name, :position).where(email: self.recipients).map do |user|
      user.attributes.select{ |k, _| User::PREVIEW_ATTRIBUTES[:attributes].include?(k.to_sym) }
    end
  end

  def last_message_preview
    self.messages.select(:message).order(created_at: :desc).limit(1).first.try(:message)
  end

  def displayed_messages
    self.messages.order(created_at: :desc).limit(10).map do |message|
      message.attributes.select{ |k, _| Message::FULL_ATTRIBUTES[:attributes].include?(k.to_sym) }
    end.reverse
  end

  private

  def sort_recipients
    self.recipients.sort!
  end
end
