# frozen_string_literal: true

# Menu class handels the menu
class Menu
  attr_reader :data

  def initialize(url)
    @url = url
    @data = []
  end

  # rubocop:disable Metrics/MethodLength
  def express_menu
    retries ||= 0
    data = []
    Scraper::Generic.new(@url).find_all('.swedish-menu .week-day').each do |element|
      food = []
      element.find_all('.dish').each do |x|
        food << { type: x.find('.dish-type').text(:all),
                  dish: x.find('.dish-name').text(:all) }
      end
      data << { menu: food, day: element.find('h2').text(:all) }
    end
    data
  rescue StandardError
    retry if (retries += 1) < 3
    'Unable to fetch menu'
  end

  def restaurant_menu
    retries ||= 0
    data = []
    Scraper::Generic.new(@url).find_all('table')[1..3].each do |element|
      tr = element.find_all('tr')[0..1]
      data << { type: tr[0].find('div').text(:all)[0..-2],
                dish: tr[1].find('div').text(:all) }
    end
    data
  rescue StandardError
    retry if (retries += 1) < 3
    'Unable to fetch menu'
  end
  # rubocop:enable Metrics/MethodLength
end
