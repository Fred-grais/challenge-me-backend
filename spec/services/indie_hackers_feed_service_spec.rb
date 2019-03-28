# frozen_string_literal: true

require "rails_helper"

RSpec.describe IndieHackersFeedService do
  describe "#initialize" do
    let(:logger_double) { double("logger") }

    subject { IndieHackersFeedService.new }
    it "should correctly initialize the service" do
      expect(Logger).to receive(:new).with(STDOUT).and_return(logger_double)
      expect(subject.instance_variable_get(:@logger)).to eq(logger_double)
    end
  end

  describe "#get_podcasts" do
    subject { IndieHackersFeedService.new.get_podcasts }

    context "call failed" do
      before do
        stub_request(:get, "http://feeds.backtracks.fm/feeds/indiehackers/indiehackers/feed.xml").
         with(
           headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
           }).
         to_return(status: 400, body: "error", headers: {})
      end

      it "should raise an error" do
        expect {
          subject
        }.to raise_error(IndieHackersFeedService::ImportFailedError).with_message("get_podcast failed with code 400, body: error")
      end
    end

    context "call succeeded" do
      before do
        stub_request(:get, "http://feeds.backtracks.fm/feeds/indiehackers/indiehackers/feed.xml").
         with(
           headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
           }).
         to_return(status: 200, body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rss version=\"2.0\"\n     xmlns:atom=\"http://www.w3.org/2005/Atom\"\n     xmlns:itunes=\"http://www.itunes.com/dtds/podcast-1.0.dtd\"\n
          xmlns:sy=\"http://purl.org/rss/1.0/modules/syndication/\"\n     xmlns:content=\"http://purl.org/rss/1.0/modules/content/\"\n>\n   <channel>\n      \n      <title><![CDATA[The Indie Hackers Podcast]]></title>\n      <description><![CDATA[I'm Courtland Allen, and on <a href=\"https://indiehackers.com\" target=\"_blank\">IndieHackers.com</a> I've interviewed hundreds of developers about how they've built, marketed, and grown their side projects into profitable online businesses. The Indie Hackers Podcast dives even deeper into the strategies and tactics behind making money online. I'll be speaking with the founders of businesses both big and small, from people working a few hours a week on side projects that generate $500/month, to CEOs who've grown their startups to millions of dollars in annual revenue. Whether you're currently running your own business or you're an aspiring entrepreneur, you'll learn by example the fundamentals behind coming up with valuable ideas, testing the market to see if they'll work, finding your first customers, marketing and growing your business, and becoming a financially independent indie hacker.]]></description>\n      <link>https://www.indiehackers.com</link>\n      <lastBuildDate>Fri, 22 Mar 2019 12:43:36 +0000</lastBuildDate>\n      <pubDate>Fri, 14 Jul 2017 15:21:17 +0000</pubDate>\n      <sy:updatePeriod>hourly</sy:updatePeriod>\n      <sy:updateFrequency>1</sy:updateFrequency>\n      <ttl>60</ttl>\n      <generator>https://backtracks.fm</generator>\n      <language>en</language>\n       <copyright>Copyright 2018 Courtland Allen</copyright>\n      <docs>https://www.indiehackers.com</docs>\n      <image>\n         <url>https://feeds.backtracks.fm/feeds/series/fafac956-68a7-11e7-9428-0e6e2408d686/images/main.jpg?1553258617049</url>\n         <title><![CDATA[The Indie Hackers Podcast]]></title>\n         <link>https://www.indiehackers.com</link>\n      </image>\n      <itunes:image href=\"https://feeds.backtracks.fm/feeds/series/fafac956-68a7-11e7-9428-0e6e2408d686/images/main.jpg?1553258617049\" />\n      <itunes:type>episodic</itunes:type>\n      <itunes:subtitle><![CDATA[Learn how the founders behind profitable online businesses turned their ideas into reality, found customers, quit their jobs, and became financially independent. ✊]]></itunes:subtitle>\n      <itunes:author>Courtland Allen</itunes:author>\n      <managingEditor>Indie Hackers (courtland@indiehackers.com)</managingEditor>\n      <atom:link rel=\"self\" type=\"application/rss+xml\" href=\"https://feeds.backtracks.fm/feeds/indiehackers/indiehackers/feed.xml\" />\n      <itunes:owner>\n
                <itunes:name><![CDATA[Indie Hackers]]></itunes:name>\n         <itunes:email>courtland@indiehackers.com</itunes:email>\n      </itunes:owner>\n      <itunes:explicit>no</itunes:explicit>\n      \n      <itunes:category text=\"Business\">\n\t\t<itunes:category text=\"Management &amp; Marketing\" />\n\t</itunes:category>\n      \n      <itunes:category text=\"Business\" />\n      \n      <itunes:category text=\"Technology\" />\n      \n      \n      <item>\n         <title><![CDATA[#086 – How to Build a Life You Love by Quitting Everything Else with Lynne Tye of Key Values]]></title>\n         \n         <itunes:episodeType>full</itunes:episodeType>\n         \n         \n         \n         \n         <guid isPermaLink=\"false\"><![CDATA[158b5efc-4c4a-11e9-9ed6-0e682b96a9c0]]></guid>\n         \n         <pubDate>Fri, 22 Mar 2019 02:32:00 +0000</pubDate>\n         <itunes:duration>01:40:35</itunes:duration>\n         <itunes:explicit>no</itunes:explicit>\n         <itunes:image href=\"https://feeds.backtracks.fm/feeds/series/fafac956-68a7-11e7-9428-0e6e2408d686/images/main.jpg?1553258617219\" />\n
          <description><![CDATA[<p>After spending years pursuing a career in science, Lynne Tye (@lynnetye) shocked her family and colleagues by dropping out of grad school. Thus began a months-long journey of discovery and experimentation that eventually saw her managing 150 people at a high-profile tech startup. But when Lynne realized the fast-paced startup lifestyle was not for her, she quit that, too, and began her search all over again. In this episode, Lynne shares the story behind how she took her career into her own hands, learned to code, and started a business doing what she loves.<br><br>Transcript, speaker information, and more: https://www.indiehackers.com/podcast/086-lynne-tye-of-key-values<br></p>]]></description>\n         <content:encoded><![CDATA[<p>After spending years pursuing a career in science, Lynne Tye (@lynnetye) shocked her family and colleagues by dropping out of grad school. Thus began a months-long journey of discovery and experimentation that eventually saw her managing 150 people at a high-profile tech startup. But when Lynne realized the fast-paced startup lifestyle was not for her, she quit that, too, and began her search all over again. In this episode, Lynne shares the story behind how she took her career into her own hands, learned to code, and started a business doing what she loves.<br><br>Transcript, speaker information, and more: https://www.indiehackers.com/podcast/086-lynne-tye-of-key-values<br></p>]]></content:encoded>\n         <link>https://www.indiehackers.com/podcast/086-lynne-tye-of-key-values</link>\n         <enclosure url=\"https://backtracks.fm/indiehackers/pr/158811ca-4c4a-11e9-9ed6-0e682b96a9c0/086-lynne-tye-of-key-values.mp3?s=1&amp;sd=1&amp;u=1553258610\" length=\"72538480\" type=\"audio/mpeg\" />\n      </item>\n      \n   </channel>\n</rss>", headers: {})
      end

      it "should import the podcast" do
        expect {
          subject
        }.to change { Podcast.count }.by(1)

        last_podcast = Podcast.last

        expect(last_podcast.title).to eq("#086 \u2013 How to Build a Life You Love by Quitting Everything Else with Lynne Tye of Key Values")
        puts last_podcast.description
        expect(last_podcast.description).to eq("<p>After spending years pursuing a career in science, Lynne Tye (@lynnetye) shocked her family and colleagues by dropping out of grad school. Thus began a months-long journey of discovery and experimentation that eventually saw her managing 150 people at a high-profile tech startup. But when Lynne realized the fast-paced startup lifestyle was not for her, she quit that, too, and began her search all over again. In this episode, Lynne shares the story behind how she took her career into her own hands, learned to code, and started a business doing what she loves.<br><br>Transcript, speaker information, and more: https://www.indiehackers.com/podcast/086-lynne-tye-of-key-values<br></p>")
        expect(last_podcast.categories).to eq(["Business", "Technology", "Management", "Marketing"])
        expect(last_podcast.duration).to eq("01:40:35")
        expect(last_podcast.publishing_date).to eq(Time.parse("2019-03-22 02:32:00.000000000 +0000"))
        expect(last_podcast.thumbnail_url).to eq("https://feeds.backtracks.fm/feeds/series/fafac956-68a7-11e7-9428-0e6e2408d686/images/main.jpg?1553258617219")
        expect(last_podcast.content_url).to eq("https://backtracks.fm/indiehackers/pr/158811ca-4c4a-11e9-9ed6-0e682b96a9c0/086-lynne-tye-of-key-values.mp3?s=1&sd=1&u=1553258610")
        expect(last_podcast.original_link).to eq("https://www.indiehackers.com/podcast/086-lynne-tye-of-key-values")
      end
    end
  end
end
