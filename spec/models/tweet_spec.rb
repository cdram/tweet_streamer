require 'rails_helper'
require 'minitest/spec'
require 'minitest/autorun'

context 'ES test', elasticsearch: true, commit: true do
  describe Tweet do

    it 'should create an index' do
      i = Tweet.create_index! force: true, index: 'tweets_rspec'
      expect(i['acknowledged']).eql?true
    end

    it 'is valid with a text, coordinates and entities' do
      tweet_hash = {:text => '#SFGiants Rocks', coordinates: {:type =>'Point', :coordinates =>[22.094835, 44.065969]},
                    entities: {:hashtags =>[], :trends =>[], :urls =>[], :user_mentions =>[], :symbols=>[]}, id: '643178675857440768'}
      tweet = Tweet.new tweet_hash
      expect(Tweet.find('643178675857440768')).to be_valid
    end

    it 'is valid with a text alone' do
      tweet_hash = {:text => '#49ers Rocks', id: '643178675857442222'}
      Tweet.new tweet_hash
      expect(Tweet.find('643178675857440768')).to be_valid
    end

    it 'should find the closest tweets in NY' do
      t1=  {:text =>'tweet1 #TB #google', :coordinates => {:type => 'Point',:coordinates =>[-73.99173,40.726006]},:entities => {:hashtags => [{:text => 'TB'}, {:text => 'google'}]}}
      t2= {:text  =>'tweet2 #TB',:coordinates => {:type => 'Point',:coordinates =>[-73.996745,40.720772]},:entities => {:hashtags => [{:text => 'TB'}]}}
      t3= {:text  =>'tweet3 #TB',:coordinates => {:type => 'Point',:coordinates =>[-73.999825,40.721992]},:entities => {:hashtags => [{:text => 'TB'}]}}
      Tweet.new t1
      Tweet.new t2
      Tweet.new t3

      nearby = Tweet.nearby 40.718,-73.983, 2, 'km'
      expect(nearby.hits.hits.size).to be >= 3
    end


    it 'should find the closest tweets in NY with  hashtags' do
      t1=  {:text =>'tweet1 #TB #google', :coordinates => {:type => 'Point',:coordinates =>[-73.99173,40.726006]},:entities => {:hashtags => [{:text => 'TB'}, {:text => 'google'}]}}
      t2= {:text  =>'tweet2 #TB',:coordinates => {:type => 'Point',:coordinates =>[-73.996745,40.720772]},:entities => {:hashtags => [{:text => 'TB'}]}}
      t3= {:text  =>'tweet3 #TB',:coordinates => {:type => 'Point',:coordinates =>[-73.999825,40.721992]},:entities => {:hashtags => [{:text => 'TB'}]}}
      Tweet.new t1
      Tweet.new t2
      Tweet.new t3

      nearby = Tweet.nearby 40.718,-73.983, 2, 'km', ['TB', 'google']
      expect(nearby.hits.hits.size).to be >= 1
    end

  end
end

