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



end
