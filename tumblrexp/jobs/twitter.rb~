require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
Twitter.configure do |config|
  config.consumer_key = 'qGGUqLsAEwbO0fxi4iwQ'
  config.consumer_secret = 'feAiyYkpcghbfBLkTjmjfcHUBhirVXE464iadzqSAA'
  config.oauth_token = '415108474-EDaHdvwquI575tFuPYXUlHMw111v5nuDVIe1dbEO'
  config.oauth_token_secret = 'lffWmNQ9Xu5wc6iQniTqVy9Nu8ntA6OPc9ESne35r8'
end

search_term = URI::encode('#todayilearned')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = Twitter.search("#{search_term}").results

    if tweets
      tweets.map! do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
