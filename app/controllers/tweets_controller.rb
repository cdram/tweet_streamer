class TweetsController < ApplicationController

  def index
    unless params[:search].nil? or params[:search][:latitude].nil? or params[:search][:longitude].nil? or params[:search][:radius].nil?
      htags = []

      htags = params[:search][:hashtags].split(',') unless params[:search][:hashtags].nil?
      nearby = Tweet.nearby params[:search][:latitude].to_f, params[:search][:longitude].to_f,  params[:search][:longitude].to_i, 'km', htags
      @tweets = []

      picture =  {
          :url => 'http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|00D900',
          :width =>  36,
          :height => 36
      }

      @hash = Gmaps4rails.build_markers(nearby.hits.hits) do |tweet, marker|
        marker.lat tweet._source.coordinates.coordinates[1]
        marker.lng tweet._source.coordinates.coordinates[0]
        marker.picture picture
        marker.infowindow tweet._source.text
        hash = {:tweet => tweet._source.text, :time => Time.parse(tweet._source.created_at).in_time_zone('Pacific Time (US & Canada)')}
        @tweets.append hash
      end
    end
  end
end

