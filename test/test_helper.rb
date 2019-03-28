# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"
require "mocha/minitest"
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

Timecop.safe_mode = true

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include AuthenticationHelper
  include Devise::Test::IntegrationHelpers
  # Add more helper methods to be used by all tests here...
end
