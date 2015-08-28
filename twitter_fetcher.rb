require 'sinatra'
require 'sinatra/jsonp'
require 'rubygems'
require 'twitter'
require 'pry'
require './secrets'

class TwitterFetcher < Sinatra::Base
  helpers Sinatra::Jsonp

  @@twitter_client = Twitter::Client.new(
    :consumer_key       => ENV['consumer_key'],
    :consumer_secret    => ENV['consumer_secret'],
    :oauth_token        => ENV['oauth_token'],
    :oauth_token_secret => ENV['oath_token_secret'],
  )

  get '/' do
    @tweets = []
    @@twitter_client.search('#Portland', result_type: "recent").results.map do |tweet|
      @tweets.push "#{tweet.user.screen_name}: #{tweet.text}"
    end
    erb :tweets
  end



end
