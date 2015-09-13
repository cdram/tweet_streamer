namespace :twitter do

  desc 'Listen to the Twitter Public Stream and index tweets'
  task :public => :environment do
    TweetStream::Client.new.sample do |status|
        #index tweets into elastic search via persistence
        tweet = Tweet.new status
        tweet.save
    end
  end
end
