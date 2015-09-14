require 'elasticsearch/persistence/model'

class Tweet
  include Elasticsearch::Persistence::Model


  # settings index: { number_of_shards: 1 } do
  #   mappings dynamic: 'false' do
  #     indexes :text, type: 'string'
  #   end
  # end


  # mappings do
  #   indexes :text, type: 'string'
  #   indexes :coordinates do
  #     indexes :coordinates, type: 'geo_point'
  #     indexes :type, type: 'string'
  #   end
  # end


  attribute :text, String
  attribute :coordinates, Hash , mapping: {type: 'object', properties: {coordinates: {type: 'geo_point',  geohash: true,
                                          geohash_prefix: true,  geohash_precision: 10}, type: {type: 'string'}}}
  attribute :entities, Hash, mapping: {type: 'object'}


  def self.nearby(lat, lng, distance, unit = 'mi', hashtags = [])
    query = {
        :size => 250,
        :query => {
            :filtered => {
                :filter => {
                    :geohash_cell => {
                        :coordinates => {
                            :lat =>  lat,
                            :lon => lng
                        },
                        :neighbors =>  true,
                        :precision => distance.to_s+unit
                    }
                }, :_cache => true
            },
        },
        :sort => { :created_at => { :order => 'desc' }}
    }

    unless hashtags.empty?
      query[:query][:filtered][:query] = {
          :bool => {
              :must => [
                  {
                      :query_string => {
                          :default_field => 'tweet.entities.hashtags.text',
                          :query => hashtags.join(' ')
                      }
                  }
              ]
          }
      }
    end

    response = Hashie::Mash.new (Tweet.search query).response
    response.hits.hits.each do |tweet|
      p tweet._source.text   + "  " + tweet._source.created_at
    end
    response
  end

end
