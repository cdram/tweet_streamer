namespace :tweets do

  desc 'create the tweets index'
  task :create => :environment do
    Tweet.create_index! force: true
    p Tweet.mapping.to_hash
  end

  desc 'Listen to the Twitter Public Stream and index tweets'
  task :listen => :environment do
    # TweetStream::Client.new.sample do |status|
    #     #index tweets into elastic search via persistence
    #     tweet = Tweet.new status
    #     tweet.save
    # end

    # Constructed the bounding box
    TweetStream::Client.new.locations([-172.2862743405,-56.9534311819,178.8904876709,83.6080303819]) do |status|
      tweet = Tweet.new status
      tweet.save
    end
  end
end
