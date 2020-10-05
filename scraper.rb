require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'net/http'
require 'uri'

Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = 'http://carbonatescreen.azurewebsites.net/menu/week/johanneberg-express/3d519481-1667-4cad-d2a3-08d558129279'
Capybara.default_max_wait_time = 10
module Scraper
  class Express
    include Capybara::DSL
    def fetch_menu
      z = visit('/')
      self.find_all('.swedish-menu .week-day')
    end
  end
end


class App
  def initialize(channel, url)
    @channel = URI.parse(channel)
    @webhook_uri = url
    @data = []
  end

  def get_menu()
    t = Scraper::Express.new
    storage = []
    t.fetch_menu.each do |element|
        day = element.find('h2').text(:all)
        food = []
        element.find_all('.dish .dish-name').each do |dish|
            food << dish.text(:all)
        end
        @data << {menu: food, day: day}
      end
  end

  def post_todays_menu()
    get_menu()
    @data.each do |day| 
      return command_bot_to_speak(day[:menu]) if day[:day] == current_day() 
    end
  end

  def command_bot_to_speak(data)
    str = "På Express serveras det idag \nExpress: #{data[0]} \nExpress Vegan: #{data[1]}"
    data = {
      "channel": @channel,
      "blocks": [
        {
          "type": "section",
          "text": {
            "type": "mrkwn",
            "text": str
          }
        }
      ]
    }
    
    header = {'Content-Type': 'text/json'}
    
    http = Net::HTTP.new(@webhook_uri)
    return str
  end

  def current_day
    x = DateTime.new
    days = {'1': 'Måndag', '2': 'Tisdag', '3': 'Onsdag', '4': 'Torsdag', '5': 'Fredag'}
    temp = x.day.to_s.to_sym
    days[temp]
  end
end

x = App.new
puts x.post_todays_menu()
