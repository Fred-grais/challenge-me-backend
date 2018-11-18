class Project < ApplicationRecord

  include FrontDataGeneration

  acts_as_taggable_on :activity_sectors, :challenges_needed

  belongs_to :user

  validates_uniqueness_of :name, scope: :user_id

  PREVIEW_ATTRIBUTES = {
      attributes: [:id, :name, :description],
      methods:  [:owner_preview]
  }

  FULL_ATTRIBUTES = {
    attributes: [:id, :name, :description, :timeline],
    methods: [:owner_full, :activity_sector_list, :challenges_needed_list]
  }

  def owner_preview
    self.user.attributes.select{ |k, _| User::PREVIEW_ATTRIBUTES[:attributes].include?(k.to_sym) }
  end

  def owner_full
    self.user.attributes.select{ |k, _| User::FULL_ATTRIBUTES[:attributes].include?(k.to_sym) }
  end
end
