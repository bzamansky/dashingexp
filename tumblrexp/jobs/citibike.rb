require 'rubygems'
require 'json'
require 'net/http'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new


def getStations()
  
  url = "http://citibikenyc.com/stations/json"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body
  result = JSON.parse(data)

  num = result['stationBeanList'].length
  bikes = 0
  total = 0
  
  result['stationBeanList'].each do |station|
    total += station['totalDocks']
    bikes += station['totalDocks']-station['availableDocks']
  end

  return {value: (1.0*bikes/total)*100}

end

last_val = getStations()
cur_val = 0

scheduler.every '2s' do
  last_val = cur_val
  cur_val = getStations()
  send_event('citibike', cur_val)
  send_event('valuation', {current: cur_val['value'], last: last_val})
end


if __FILE__ == $0
  puts getStations()
end
