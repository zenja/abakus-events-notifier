require 'sinatra'
require './abakus.rb'
require './zenja_twitter.rb'

before do
  @zt = ZenjaTwitter.new
end

get '/' do
  erb :index
end

get '/check' do
  abakus = Abakus.new

  # get all company events
  @company_events = abakus.get_company_events

  # add if_can_register to the hash of each event
  @company_events.each do |event|
    if abakus.if_can_register(event[:url])
      event[:if_can_register] = true
    end
  end

  erb :check
end

get '/check-and-notify' do
  abakus = Abakus.new

  # get all company events
  @company_events = abakus.get_company_events

  # add if_can_register to the hash of each event
  @company_events.each do |event|
    if abakus.if_can_register(event[:url])
      event[:if_can_register] = true
    end
  end

  # notify events which can be registered via Twitter
  @company_events.each do |event|
    if event[:if_can_register] == true
      # notify via twitter
      @zt.tweet "#abakus_company_event You can now register the company event: \"#{event[:title]}\". URL: #{event[:url]}"
    end
  end

  erb :check
end
