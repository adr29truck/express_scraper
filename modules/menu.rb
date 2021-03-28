# frozen_string_literal: true

# Menu class handels the menu
class Menu
  attr_reader :data

  def initialize(url)
    @url = url
    @data = []
  end

  # rubocop:disable Metrics/MethodLength
  def menu
    retries ||= 0
    data = []
    Scraper::Generic.new(@url).find_all('.swedish-menu .week-day').each do |element|
      food = []
      element.find_all('.dish', minimum: 1).each do |x|
        food << { type: x.find('.dish-type').text(:all),
                  dish: x.find('.dish-name').text(:all) }
      end
      data << { menu: food, day: element.find('h2').text(:all) }
    end
    data
  rescue StandardError
    retry if (retries += 1) < 3
    data << { menu: [{ type: 'undefined', dish: 'undefined' }], day: 'undefined' }
    data
  end
  # rubocop:enable Metrics/MethodLength
end
