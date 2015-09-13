namespace :tweets do

  desc 'create the tweets index'
  task :create => :environment do
    Tweet.create_index! force: true
    p Tweet.mapping.to_hash
  end

  desc 'Listen to the Twitter Public Stream and index tweets'
  task :listen => :environment do
    TweetStream::Client.new.sample do |status|
        #index tweets into elastic search via persistence
        tweet = Tweet.new status
        tweet.save
    end
  end
end
