# frozen_string_literal: true

require 'json'
# require 'simplecov'
# require 'coveralls'
require 'byebug' unless ENV['TRAVIS']

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# SimpleCov.formatter = Coveralls::SimpleCov::Formatter
# SimpleCov.start('rails') do
#   add_filter '/lib/generators'
#   add_filter '/spec'
#   add_filter '/tasks'
#   add_filter '/lib/covid_tracker/version.rb'
# end
# SimpleCov.command_name 'spec'
#
# Coveralls.wear!

require 'factory_bot_rails'
require 'rspec/rails'
require 'rspec/its'
require 'rspec/matchers'
require 'rspec/active_model/mocks'
require 'webmock/rspec'
require 'database_cleaner'
require 'covid_tracker/keys'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = File.expand_path("../fixtures", __FILE__)

  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Disable Webmock if we choose so we can test against the authorities, instead of their mocks
  WebMock.disable! if ENV["WEBMOCK"] == "disabled"

  config.infer_spec_type_from_file_location!

  config.include FactoryBot::Syntax::Methods
end

def webmock_fixture(fixture)
  File.new File.expand_path(File.join("../fixtures", fixture), __FILE__)
end

# returns the file contents
def load_fixture_file(fname)
  File.open(Rails.root.join('spec', 'fixtures', fname)) do |f|
    return f.read
  end
end
