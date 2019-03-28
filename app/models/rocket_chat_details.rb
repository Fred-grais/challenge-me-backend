# frozen_string_literal: true

class RocketChatDetails < ApplicationRecord
  include FrontDataGeneration

  belongs_to :rocketable, polymorphic: true

  PREVIEW_ATTRIBUTES = {
      attributes: [:name],
      methods: []
  }

  FULL_ATTRIBUTES = {
      attributes: [:name],
      methods: []
  }
end
