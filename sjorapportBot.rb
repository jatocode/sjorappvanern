#!/usr/bin/env ruby
# encoding: UTF-8
gem 'twitter', '5.11.0'
require 'twitter'
require 'rss'
require 'open-uri'
require 'yaml'

def update(client)
    now = Time.new
     if (now.hour==6 and now.min==20) or
         (now.hour==13 and now.min==20) or 
         (now.hour==16 and now.min==20) or 
         (now.hour==22 and now.min==20)
        puts "Dags att twittra väder"

        url = 'http://feed43.com/tobias_sjorapport.xml'
        open(url) do |rss|
            feed = RSS::Parser.parse(rss)
            feed.items.each do |item|
                if item.title =~ /nern/
                    strtime = now.strftime("%H:%M")
                    client.update("#{strtime}, #{item.title}")
                    puts "#{strtime}: #{item.title}" 
                end 
            end
        end

    end
end

keys = YAML.load_file('keys.yml')
config = {
    consumer_key: keys['consumer_key'],
    consumer_secret: keys['consumer_secret'],
    access_token: keys['access_token'],
    access_token_secret: keys['access_token_secret']
}

rClient = Twitter::REST::Client.new config
sClient = Twitter::Streaming::Client.new config
puts "Starting twitter bot"
while true
    begin
        update(rClient)
        sleep 60
    end
end

