# frozen_string_literal: true

class PodcastsController < ApplicationController
  def index
    puts Podcast.all
    render json: Podcast.take_random.as_json(for_front: true)
  end
end
