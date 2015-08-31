require 'sinatra'
require 'sinatra/jsonp'
require 'rubygems'
require 'twitter'
require 'pry'
require './secrets'
require 'sinatra/reloader'

class TwitterFetcher < Sinatra::Base
  helpers Sinatra::Jsonp

  @@twitter_client = Twitter::Client.new(
    :consumer_key       => ENV['consumer_key'],
    :consumer_secret    => ENV['consumer_secret'],
    :oauth_token        => ENV['oauth_token'],
    :oauth_token_secret => ENV['oath_token_secret'],
  )



  get '/' do
     erb :index
  end

  post '/search' do
    query = params['query']
    if query.include?(' ')
      query.gsub!(' ', '+')
    end

    redirect "/search/#{query}"
  end


  get '/search/:query' do
    query = params['query']
    if query.include?('+')
      query.gsub!('+', ' ')
    end
    @tweets = []
    @@twitter_client.search("#{query}", {result_type: 'recent', geocode: "45.5434085,-122.654422,8mi", count: 50}).results.map do |tweet|
      @tweets.push "<img src='#{tweet.user.profile_image_url}' alt='img'> #{tweet.user.screen_name}: #{tweet.text} **** #{tweet.user.location}"
    end
    erb :tweets
  end

end
