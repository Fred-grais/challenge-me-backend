class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  include FrontDataGeneration

  has_many :projects
  has_many :conversations, -> (user) do
    unscope(where: :user_id).where('recipients @> ARRAY[?]::varchar[]', user.email)
  end do

    def create(params)
      params = params.respond_to?(:with_indifferent_access) ? params.with_indifferent_access : params
      recipients = Set.new(params[:recipients])
      recipients.add(proxy_association.owner.email)
      Conversation.create(recipients: recipients.to_a)
    end
  end


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

end