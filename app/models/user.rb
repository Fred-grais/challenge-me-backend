# frozen_string_literal: true

class User < ApplicationRecord
  include AASM

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User
  include FrontDataGeneration

  has_one :rocket_chat_details, as: :rocketable
  has_one :ghost_credentials
  has_many :projects

  has_one_attached :avatar
  # has_many :conversations, -> (user) do
  #   unscope(where: :user_id).where('recipients @> ARRAY[?]::varchar[]', user.email)
  # end do
  #
  #   def create(params)
  #     params = params.respond_to?(:with_indifferent_access) ? params.with_indifferent_access : params
  #     recipients = Set.new(params[:recipients])
  #     recipients.add(proxy_association.owner.email)
  #     Conversation.create(recipients: recipients.to_a)
  #   end
  # end
  #
  # has_many :messages, foreign_key: :sender_id

  # after_create :create_rocket_chat_user

  PREVIEW_ATTRIBUTES = {
    attributes: %i[id first_name last_name position],
    methods: [:avatar_url]
  }.freeze

  FULL_ATTRIBUTES = {
    attributes: %i[id email first_name last_name position status twitter_id timeline],
    methods: %i[rocket_chat_profile avatar_url]
  }.freeze

  PROJECT_ATTRIBUTES_PREVIEW = {
    attributes: %i[id first_name last_name position],
    method: []
  }.freeze

  aasm column: 'status' do
    state :pending_activation, initial: true
    state :active
    state :inactive

    event :manage_status do
      transitions from: :pending_activation, to: :active, guard: :user_details_present?, after: :after_activate
      transitions from: :active, to: :inactive, guard: :missing_user_details?
      transitions from: :inactive, to: :active, guard: :user_details_present?

      transitions from: :active, to: :active
    end

    event :activate, after: :after_activate do
      transitions from: :pending_activation, to: :active, guard: :user_details_present?
    end

    event :deactivate do
      transitions from: :active, to: :inactive
    end

    event :reactivate do
      transitions from: :inactive, to: :active, guard: :user_details_present?
    end
  end

  def avatar_url
    if avatar.attached?
      blob = avatar.blob
      variant = avatar.variant(UploadsVariants.resize_to_fit(width: 300, height: 300, blob: blob)).processed
      Rails.application.routes.url_helpers.url_for(variant)
    end
  end

  def has_missing_user_details
    missing_user_details?
  end

  def full_name
    [first_name, last_name].compact.map(&:capitalize).join(' ')
  end

  def rocket_chat_profile
    rocket_chat_details.as_json(for_front: true)
  end

  private

  def after_activate
    create_rocket_chat_user
    create_ghost_user
  end

  def missing_user_details?
    !user_details_present?
  end

  def user_details_present?
    %w[first_name last_name position].all? { |attr| send(attr).present? }
  end

  def create_rocket_chat_user
    unless rocket_chat_details.present?
      new_rocket_chat_user = RocketChatInterface.new.create_user(self)
      create_rocket_chat_details(rocketchat_id: new_rocket_chat_user.id, name: new_rocket_chat_user.username)
    end
  end

  def create_ghost_user
    unless ghost_credentials.present?
      create_ghost_credentials(username: email, password: SecureRandom.hex(32))
    end
  end
end
