ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Patch Rails::LineFiltering for minitest 6.x compatibility.
# railties 7.0.8.1 defines run(reporter, options={}) which only works with
# minitest 5.x. minitest 6.x calls run(klass, method_name, reporter) with 3
# args and uses options[:include] as the filter key instead of options[:filter].
if Minitest::VERSION.split(".").first == "6"
  require "rails/test_unit/runner"
  module Rails
    module LineFiltering
      remove_method :run if method_defined?(:run)
      def run_suite(reporter, options = {})
        options = options.merge(include: Rails::TestUnit::Runner.compose_filter(self, options[:include]))
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
