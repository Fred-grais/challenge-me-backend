# frozen_string_literal: true

class Project < ApplicationRecord
  include FrontDataGeneration

  acts_as_taggable_on :activity_sectors, :challenges_needed

  belongs_to :user

  has_one :rocket_chat_details, as: :rocketable
  has_one_attached :logo
  has_many_attached :pictures

  validates_uniqueness_of :name, scope: :user_id

  after_create :create_rocket_chat_group

  PREVIEW_ATTRIBUTES = {
    attributes: %i[id name description],
    methods: %i[owner_preview logo_url]
  }.freeze

  FULL_ATTRIBUTES = {
    attributes: %i[id name description timeline],
    methods: %i[owner_full activity_sector_list challenges_needed_list rocket_chat_profile logo_url pictures_urls]
  }.freeze

  def owner_preview
    current_user = user

    User::PREVIEW_ATTRIBUTES.values.flatten.each_with_object({}) do |attr, h|
      h[attr] = current_user.send(attr)
    end
  end

  def owner_full
    current_user = user

    User::FULL_ATTRIBUTES.values.flatten.each_with_object({}) do |attr, h|
      h[attr] = current_user.send(attr)
    end
  end

  def rocket_chat_profile
    rocket_chat_details.as_json(for_front: true)
  end

  def logo_url
    if logo.attached?
      blob = logo.blob
      variant = logo.variant(UploadsVariants.resize_to_fit(width: 200, height: 200, blob: blob)).processed
      Rails.application.routes.url_helpers.url_for(variant)
    end
  end

  def pictures_urls
    if pictures.attached?
      pictures.map do |picture|
        blob = picture.blob
        variant = picture.variant(UploadsVariants.resize_to_fit(width: 200, height: 200, blob: blob)).processed
        Rails.application.routes.url_helpers.url_for(variant)
      end
    end
  end

  private

  def create_rocket_chat_group
    unless rocket_chat_details.present?
      handler_instance = RocketChatInterface.new
      new_rocket_chat_group = handler_instance.create_group(name)

      begin
        handler_instance.add_moderator_to_group(new_rocket_chat_group.id, user.rocket_chat_details.rocketchat_id)
      rescue StandardError => e
        raise e unless e.message.include?('error-user-already-owner')
      end

      create_rocket_chat_details(rocketchat_id: new_rocket_chat_group.id, name: new_rocket_chat_group.name)
    end
  end
end
