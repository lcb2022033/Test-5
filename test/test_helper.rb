ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Minitest 6.x changed Runnable.run to run(klass, method_name, reporter).
# Rails::LineFiltering#run still uses the minitest 5.x signature (reporter, options = {}).
# Patch it to accept the new signature so tests can run.
if Gem::Version.new(Minitest::VERSION) >= Gem::Version.new("6")
  module Rails
    module LineFiltering
      def run(klass, method_name, reporter)
        super
      end
    end
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
