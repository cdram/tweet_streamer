# require 'elasticsearch'
#
#
# client = Elasticsearch::Client.new log: true
#  mappings = {
#          :tweet => {
#              :properties => {
#                  :text => {
#                      :type => 'string'
#                  },
#                  :coordinates => {
#                      :properties => {
#                          :coordinates => {
#                              :type => 'geo_point'
#                          },
#                          :type => {
#                              :type => 'string'
#                          }
#                      }
#                  },
#                  :created_at => {
#                      :type => 'date',
#                      :format => 'dateOptionalTime'
#                  },
#                  :updated_at => {
#                      :type => 'date',
#                      :format => 'dateOptionalTime'
#                  }
#              }
#          }
#  }
#
# client.index index:'tweets', type: 'tweet'
# client.indices.put_mapping index: 'tweets',  type: 'tweet', body: mappings
#
#
#
#


#Create an index at the time of deploy!
Tweet.create_index! force: true
p Tweet.mapping.to_hash
