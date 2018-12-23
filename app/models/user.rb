class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  include FrontDataGeneration

  has_many :projects
  has_many :conversations
  has_many :messages, foreign_key: :sender_id

  PREVIEW_ATTRIBUTES = {
      attributes: [:id, :first_name, :last_name, :position],
      methods: []
  }

  FULL_ATTRIBUTES = {
      attributes: [:id, :email, :first_name, :last_name, :position],
      methods: []
  }

  PROJECT_ATTRIBUTES_PREVIEW = {
      attributes: [:id, :first_name, :last_name, :position],
      method: []
  }

  def conversations
    Conversation.where('recipients @> ARRAY[?]::varchar[]', self.email)
  end
end
