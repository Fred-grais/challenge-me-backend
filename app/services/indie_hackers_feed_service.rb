# frozen_string_literal: true

class IndieHackersFeedService
  class IndieHackersFeedServiceError < StandardError
  end

  class ImportFailedError < IndieHackersFeedServiceError
  end

  PODCASTS_FEED = "http://feeds.backtracks.fm/feeds/indiehackers/indiehackers/feed.xml"

  def initialize
    @logger = Logger.new(STDOUT)
  end

  def get_podcasts
    response = HTTParty.get(IndieHackersFeedService::PODCASTS_FEED)
    if response.code == 200
      parsed_response = Nokogiri::XML.parse(response.body)
      parsed_response.remove_namespaces!

      imported_podcasts = []
      parsed_response.css("item").each do |item|
        imported_podcasts.push(
          Podcast.create(
            title: item.css("title").text,
            description: item.css("description").text,
            categories: %w(Business Technology Management Marketing),
            duration: item.css("duration").text,
            publishing_date: DateTime.parse(item.css("pubDate").text),
            thumbnail_url: item.css("image").attribute("href").value,
            content_url: item.css("enclosure").attribute("url").value,
            original_link: item.css("link").text
          )
        )
      end

      @logger.info("Imported #{imported_podcasts.count { |podcast| podcast.persisted? } } new Podcasts")
    else
      raise ImportFailedError.new("get_podcast failed with code #{response.code}, body: #{response.body}")
    end
  end
end
