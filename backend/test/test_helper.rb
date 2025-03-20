# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require "rails/test_help"
require 'factory_bot_rails'
require 'mocha/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: 12)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  include FactoryBot::Syntax::Methods
end
