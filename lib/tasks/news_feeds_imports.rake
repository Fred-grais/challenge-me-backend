namespace :news_feeds_imports do
  desc "Fetch, parse and persist indie hackers podcasts from http://feeds.backtracks.fm/feeds/indiehackers/indiehackers/feed.xml"
  task indie_hackers_podcasts: :environment do
    IndieHackersFeedService.new.get_podcasts
  end

end
