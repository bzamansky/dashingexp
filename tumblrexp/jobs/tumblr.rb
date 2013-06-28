require 'rubygems'
require 'json'
require 'net/http'
require 'rufus/scheduler'

key = "8VCvaJ8iozRMwGfFswj9TcVsVEn7kUoKJ6VgQOfHJRAgZ7Kslg"

scheduler = Rufus::Scheduler.start_new

def getTagged(user,key)

  url = "http://api.tumblr.com/v2/blog/#{user}.tumblr.com/posts/?api_key=#{key}&limit=50"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body
  result = JSON.parse(data)

  tags = Hash.new()
  result['response']['posts'].each do |post|
    post['tags'].each do |tag|
      x = 1
      if tags[tag] == nil
        tags[tag] = {"label" => tag, "value" => 1}
      else
      x = tags[tag]['value'] + 1
      tags[tag] = {"label" => tag, "value" => x}
      end
    end
  end
  l = []
  tags.keys.each do |d|
    l.push(tags[d])
  end
  l = l.sort{|x,y| y['value'] <=> x['value']}
  return l[0..10]
end


def getPics(user,key)
  url = "http://api.tumblr.com/v2/blog/#{user}.tumblr.com/posts/?api_key=#{key}&"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body
  result = JSON.parse(data)
  
  posts = []
  result['response']['posts'].each do |post|
    posts.push(post['tags'].length)
  end

  return posts
end


scheduler.every '2s' do
  tags = getTagged("tribblesandseaturtles",key)
  #puts tags
  #tags = [{ label: 'sdcsda', value: "1"}, {label: 'asab', value: '2'}]
  send_event("tumblr", items: tags)
end


scheduler.every '2s' do
  points = []
  posts = getPics("tribblesandseaturtles",key)
  #puts posts
  (1..(posts.length-1)).each do |i|
    points << {x: i, y: posts[i]}
  end
  #puts points  
  send_event("convergence", points: points)
end

if __FILE__ == $0
  getPics("tribblesandseaturtles",key)
end
