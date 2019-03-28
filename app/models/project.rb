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
      attributes: [:id, :name, :description],
      methods:  [:owner_preview, :logo_url]
  }

  FULL_ATTRIBUTES = {
    attributes: [:id, :name, :description, :timeline],
    methods: [:owner_full, :activity_sector_list, :challenges_needed_list, :rocket_chat_profile, :logo_url, :pictures_urls]
  }

  def owner_preview
    current_user = self.user

    User::PREVIEW_ATTRIBUTES.values.flatten.inject({}) do |h, attr|
      h[attr] = current_user.send(attr)
      h
    end
  end

  def owner_full
    current_user = self.user

    User::FULL_ATTRIBUTES.values.flatten.inject({}) do |h, attr|
      h[attr] = current_user.send(attr)
      h
    end
  end

  def rocket_chat_profile
    self.rocket_chat_details.as_json(for_front: true)
  end

  def logo_url
    if self.logo.attached?
      blob = self.logo.blob
      variant = self.logo.variant(UploadsVariants.resize_to_fit(width: 200, height: 200, blob: blob)).processed
      Rails.application.routes.url_helpers.url_for(variant)
    end
  end

  def pictures_urls
    if self.pictures.attached?
      self.pictures.map do |picture|
        blob = picture.blob
        variant = picture.variant(UploadsVariants.resize_to_fit(width: 200, height: 200, blob: blob)).processed
        Rails.application.routes.url_helpers.url_for(variant)
      end
    end
  end

  private

  def create_rocket_chat_group
    unless self.rocket_chat_details.present?
      handler_instance = RocketChatInterface.new
      new_rocket_chat_group = handler_instance.create_group(self.name)

      begin
        handler_instance.add_moderator_to_group(new_rocket_chat_group.id, self.user.rocket_chat_details.rocketchat_id)
      rescue => e
        unless e.message.include?('error-user-already-owner')
          raise e
        end
      end

      self.create_rocket_chat_details(rocketchat_id: new_rocket_chat_group.id, name: new_rocket_chat_group.name)
    end
  end
end
