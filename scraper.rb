# frozen_string_literal: true

require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'net/http'
require 'uri'
require 'dotenv'

Dotenv.load
Capybara.run_server = false
Capybara.current_driver = :selenium_headless
Capybara.app_host = 'http://carbonatescreen.azurewebsites.net/menu/week/johanneberg-express/3d519481-1667-4cad-d2a3-08d558129279'
Capybara.default_max_wait_time = 10

module Scraper
  # Handles scaping
  class Express
    include Capybara::DSL
    def fetch_menu
      visit('/')
      find_all('.swedish-menu .week-day')
    end
  end
end

# Hanles the majority of functionality
class App
  def initialize(url, channel = '#lunch-menu')
    @channel = channel
    @webhook_uri = URI(url)
    @data = []
  end

  def menu
    t = Scraper::Express.new
    t.fetch_menu.each do |element|
      day = element.find('h2').text(:all)
      food = []
      element.find_all('.dish .dish-name').each do |dish|
        food << dish.text(:all)
      end
      @data << { menu: food, day: day }
    end
  end

  def post_todays_menu
    menu
    @data.each do |day|
      return command_bot_to_speak(day[:menu]) if day[:day] == current_day
    end
  end

  # rubocop:disable Metrics/MethodLength
  def command_bot_to_speak(data)
    str = "Idag #{current_day} \nExpress: #{data[0]} \nExpress Vegan: #{data[1]}"
    data = {
      "channel": @channel,
      "blocks": [
        {
          "type": 'section',
          "text": {
            "type": 'mrkdwn',
            "text": str
          }
        }
      ]
    }

    header = { 'Content-Type': 'text/json' }

    https = Net::HTTP.new(@webhook_uri.host, @webhook_uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(@webhook_uri.request_uri, header)
    request.body = data.to_json
    response = https.request(request)
    response.code
  end
  # rubocop:enable Metrics/MethodLength

  def current_day
    x = DateTime.new
    days = { '1': 'Måndag', '2': 'Tisdag', '3': 'Onsdag', '4': 'Torsdag', '5': 'Fredag' }
    temp = x.day.to_s.to_sym
    days[temp]
  end
end

require 'sinatra'

# Webserver handler
class Server < Sinatra::Base
  post '/send_menu' do
    x = App.new(ENV['WEBHOOK'])
    p x.post_todays_menu
  end
end
