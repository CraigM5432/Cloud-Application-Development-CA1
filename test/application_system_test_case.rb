require "test_helper"
require "capybara/rails"
require "capybara/minitest"
require "selenium/webdriver"

Capybara.register_driver :external_chromedriver do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.binary = "/snap/bin/chromium"

  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,900")
  options.add_argument("--remote-debugging-port=9222")

  # Connect to the existing ChromeDriver instance you started manually
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    url: "http://127.0.0.1:9515",  # <== This line tells Selenium to use your existing driver
    options: options
  )
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :external_chromedriver
end

