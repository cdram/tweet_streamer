class TweetsController < ApplicationController

  def index
    unless params[:search][:latitude].nil? or params[:search][:longitude].nil? or params[:search][:radius].nil?
      htags = []
      unless params[:search][:hashtags].nil?
        htags = params[:search][:hashtags].split(',')
      end

      nearby = Tweet.nearby params[:search][:latitude].to_f, params[:search][:longitude].to_f,  params[:search][:longitude].to_i, 'km', htags
      p nearby
      @tweets = []
      nearby.hits.hits.each do |tweet|
        hash = {:tweet => tweet._source.text, :time => Time.parse(tweet._source.created_at).in_time_zone('Pacific Time (US & Canada)')}
        @tweets.append hash
      end
    end
  end
end

