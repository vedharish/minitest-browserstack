require 'rubygems'
require 'yaml'
require 'minitest/autorun'
require 'selenium-webdriver'

class SingleTest < MiniTest::Test
  def configure
    @index = ENV['test_index'].to_i || 0
    config_path = ENV['test_config_path'] || 'config/single.config.yml'
    @username = ENV['BROWSERSTACK_USERNAME'] || config["username"]
    @access_key = ENV['BROWSERSTACK_ACCESS_KEY'] || config["access_key"]
    @config = YAML.load_file(config_path)
  end

  def setup
    configure
    url = "https://#{@username}:#{@access_key}@#{@config["server"]}/wd/hub"
    caps = @config["common_caps"].clone
    caps.merge!(@config["browser_caps"][@index])
    @driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => caps)
  end
 
  def test_google
    @driver.navigate.to "http://www.google.com/ncr"
    element = @driver.find_element(:name, 'q')
    element.send_keys "BrowserStack"
    element.submit
    assert_match(/Google/i, @driver.title)
  end
 
  def teardown
    @driver.quit
  end
end
