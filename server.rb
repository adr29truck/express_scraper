# frozen_string_literal: true

require 'dotenv'
require 'sinatra'

Dotenv.load

# Webserver handler
class Server < Sinatra::Base
  post '/send_menu' do
    x = Bot.new(ENV['WEBHOOK'])
    p x.post_todays_menu
    return 'OK'
  end
end
