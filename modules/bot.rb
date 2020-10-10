# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'dotenv'

Dotenv.load

# Hanles the majority of the bot functionality
class Bot
  def initialize(webook_url, channel = '#lunch-menu')
    @channel = channel
    @webhook_uri = URI(webook_url)
    @data = []
  end

  def post_todays_menu
    x = Menu.new('http://carbonatescreen.azurewebsites.net/menu/week/johanneberg-express/3d519481-1667-4cad-d2a3-08d558129279')
    x.menu.each do |day|
      return command_bot_to_speak parse_message(day[:menu]) if day[:day] == Time.day_of_week
    end
    'Found no match'
  end

  def parse_message(data)
    { "channel": @channel,
      "blocks": [{
        "type": 'section',
        "text": {
          "type": 'mrkdwn',
          "text": "Idag #{Time.day_of_week} \n#{data[0][:type]}: #{data[0][:dish]}" \
            "\n#{data[1][:type]}: #{data[1][:dish]}"
        }
      }] }
  end

  # rubocop:disable Metrics/MethodLength
  def command_bot_to_speak(data)
    header = { 'Content-Type': 'text/json' }

    begin
      retries ||= 0
      https = Net::HTTP.new(@webhook_uri.host, @webhook_uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(@webhook_uri.request_uri, header)
      request.body = data.to_json
      if ENV['RACK_ENV'] == 'production'
        response = https.request(request)
        response.code
      else
        puts "If RACK_ENV=production then the request would be sent. Request body: \n#{request.body}"
        200
      end
    rescue StandardError
      retry if (retries += 1) < 3
      'Unable to send webhook'
    end
  end
  # rubocop:enable Metrics/MethodLength
end
