# frozen_string_literal: true

require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium_chrome_headless_docker_friendly
Capybara.default_max_wait_time = 100

Capybara.register_driver :selenium_chrome_headless_docker_friendly do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  # Sandbox cannot be used inside unprivileged Docker container
  browser_options.args << '--no-sandbox'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

module Scraper
  # Handles scaping
  class Generic
    include Capybara::DSL

    def initialize(url)
      Capybara.app_host = url
      super()
      visit('/')
    end
  end
end
