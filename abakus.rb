#!/bin/env ruby
# encoding: utf-8

require 'mechanize'
require 'yaml'

class Abakus
  ABAKUS_ROOT = "https://abakus.no"
  
  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = "Windows Mozilla"
    login
  end

  # Login to abakus.no
  # This operation may take several seconds
  def login
    abakus_config = YAML.load(File.open("./config/_abakus_account.yaml"))
    username = abakus_config['app']['username']
    password = abakus_config['app']['password']
    
    login_page = @agent.get("https://abakus.no/user/login/")
    login_form = login_page.form_with(:action => "/user/login/")
    login_form.username = username
    login_form.password = password
    login_form.submit
  end

  def logout
    @agent.get("https://abakus.no/user/logout/")
  end

  # Get all company events, 
  # return an array of hashes like:
  # [{:title => "Google Show!", :url => "https://..."}, {...}, ...]
  def get_company_events
    company_event_page = @agent.get("https://abakus.no/event/company/")
    events_list = company_event_page.search("#eventlist")
    events_array = []
    events_list.css("li").each do |li|
      title_node = li.css("h2>a").first
      title = title_node.text
      url = ABAKUS_ROOT + title_node.attr("href")
      events_array.push({:title => title, :url => url})
    end
    return events_array
  end

  # Param: the url of an event
  # Output: true or false
  def if_can_register(url)
    event_page = @agent.get(url)
    matched_nodes = event_page.search("#normal_register > h3")
    if matched_nodes.empty?
      return false
    elsif matched_nodes[0].text == "Påmelding"
      return true
    else
      return false
    end
  end

  # This method is just for debug
  def test
    company_event_page = @agent.get("https://abakus.no/event/company/")
    events_list = company_event_page.search("#eventlist")
    events_array = []
    events_list.css("li").each do |li|
      title_node = li.css("h2>a").first
      title = title_node.text
      url = ABAKUS_ROOT + title_node.attr("href")
      events_array.push({:title => title, :url => url})
    end
    events_array.each do |event|
      puts event[:title]
      puts event[:url]
    end
  end
end

# Test code:
#abakus = Abakus.new
#abakus.test
#puts abakus.if_can_register "https://abakus.no/event/986-ernst-young/"
