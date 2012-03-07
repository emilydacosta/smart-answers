# encoding: UTF-8
require 'slimmer/test'
require_relative 'test_helper'
require 'capybara/rails'

require 'gds_api/helpers'
require 'gds_api/test_helpers/imminence'

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  include GdsApi::Helpers
  include GdsApi::TestHelpers::Imminence
end

class JavascriptIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end

  teardown do
    Capybara.use_default_driver
  end
end

if Gem.loaded_specs.keys.include?('capybara-webkit')
  require 'capybara-webkit'
  Capybara.javascript_driver = :webkit
else
  Capybara.javascript_driver = :selenium
end
Capybara.default_driver = :rack_test
Capybara.app = Rack::Builder.new do
  map "/" do
    run Capybara.app
  end
end