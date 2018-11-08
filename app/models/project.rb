class Project < ApplicationRecord

  include FrontDataGeneration

  belongs_to :user

  validates_uniqueness_of :name, scope: :user_id

  PREVIEW_ATTRIBUTES = {
      attributes: [:id, :name, :description],
      methods:  [:owner_preview]
  }

  FULL_ATTRIBUTES = {
    attributes: [:id, :name, :description, :timeline],
    methods: [:owner_full]
  }

  def owner_preview
    self.user.attributes.select{ |k, _| User::PREVIEW_ATTRIBUTES[:attributes].include?(k.to_sym) }
  end

  def owner_full
    self.user.attributes.select{ |k, _| User::FULL_ATTRIBUTES[:attributes].include?(k.to_sym) }
  end
end
