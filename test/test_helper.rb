ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'webmock/minitest'

Dir[Rails.root.join('test/support/**/*.rb')].each {|f| require f}

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include AuthenticationHelper
  include Devise::Test::IntegrationHelpers
  # Add more helper methods to be used by all tests here...
end
