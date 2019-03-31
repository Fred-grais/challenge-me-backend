# frozen_string_literal: true

class Podcast < ApplicationRecord
  include FrontDataGeneration

  validates_presence_of :title, :description, :duration, :publishing_date, :content_url

  validates_uniqueness_of :title

  FULL_ATTRIBUTES = {
    attributes: %i[title description categories duration publishing_date content_url thumbnail_url original_link]
  }.freeze

  def self.take_random
    offset = rand(Podcast.count)
    Podcast.offset(offset).first
  end
end
