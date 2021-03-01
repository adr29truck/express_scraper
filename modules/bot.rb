# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'dotenv'

Dotenv.load

# Hanles the majority of the bot functionality
class Bot
  # rubocop:disable Metrics/MethodLength
  def initialize(webook_url, channel = '#lunch-menu')
    @channel = channel
    @webhook_uri = URI(webook_url)
    @data = []
    @urls = [
      { url: 'http://carbonatescreen.azurewebsites.net/menu/week/johanneberg-express/3d519481-1667-4cad-d2a3-08d558129279',
        name: 'Express' },
      { url: 'http://carbonatescreen.azurewebsites.net/menu/week/karrestaurangen/21f31565-5c2b-4b47-d2a1-08d558129279',
        name: 'Kårrestaurangen' }
    ]
    @attempt = 1
    @closed_message = 'Stängt. Lunch serveras i Kårrestaurangen'
  end
  # rubocop:enable Metrics/MethodLength

  def post_todays_menu
    x = Menu.new(@urls.first[:url])
    x.menu.each do |day|
      return command_bot_to_speak parse_message(day[:menu]) if day[:day] == Time.day_of_week
    end
    'Found no match'
  rescue StandardError
    'Found no match'
  end

  def get_alternative_restaurant_menu(entity, pre_text)
    @attempt += 1
    m = Menu.new(entity[:url])
    pre_text += "\n*#{entity[:name]}*"
    m.menu.each do |day|
      return parse_message(day[:menu], pre_text) if day[:day] == Time.day_of_week
    end
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def parse_message(data, pre_text = '')
    raise 'Wrong data' if data[0][:type].nil? || data[0][:dish].nil?

    if data.first[:dish] == @closed_message || data.first[:dish] == ''
      if @urls.length > @attempt
        get_alternative_restaurant_menu(@urls[@attempt], "#{data[0][:type]}: #{data.first[:dish] == '' ? 'Null Value': @closed_message}")
      end
    else
      text = "*Idag #{Time.day_of_week}* \n#{pre_text.chomp}".chomp
      text += "\n"

      data.each do |e|
        text += "#{e[:type]}: #{e[:dish]}\n"
      end

      { "channel": @channel,
        "text": text.chomp.gsub('*', ''),
        "blocks": [{
          "type": 'section',
          "text": {
            "type": 'mrkdwn',
            "text": text.chomp
          }
        }] }
    end
  rescue StandardError
    { "channel": @channel,
      "blocks": [
        {
          "type": 'image',
          "image_url": 'https://www.reactiongifs.com/r/whapc.gif',
          "alt_text": 'Something is broken'
        },
        {
          "type": 'section',
          "text": {
            "type": 'mrkdwn',
            "text": 'Something went wrong.'
          },
          "accessory": {
            "type": 'button',
            "text": {
              "type": 'plain_text',
              "text": 'Create issue on GitHub',
              "emoji": true
            },
            "value": 'click_me_123',
            "url": 'https://github.com/adr29truck/express_scraper',
            "action_id": 'button-action'
          }
        }
      ] }
  end

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
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
