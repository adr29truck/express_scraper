# frozen_string_literal: true

require 'net/http'
require 'uri'

# Handles time logic
class Time
  def self.day_of_week
    retries ||= 0
    uri = URI('https://worldtimeapi.org/api/timezone/Europe/Amsterdam')
    time = JSON.parse(Net::HTTP.get(uri))
    days = { '1': 'Måndag', '2': 'Tisdag', '3': 'Onsdag', '4': 'Torsdag', '5': 'Fredag', '6': 'Lördag', '0': 'Söndag' }
    temp = time['day_of_week'].to_s.to_sym
    days[temp]
  rescue StandardError
    retry if (retries += 1) < 3
    'Unable to fetch current day'
  end
end
