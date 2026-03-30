ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

# Rails 7.0's sqlite3 adapter requires gem "sqlite3", "~> 1.4", but sqlite3 2.x
# is installed. Relax the version check so Rails can load the adapter.
module Kernel
  prepend(Module.new do
    def gem(dep, *reqs)
      reqs = [">= 1.4"] if dep == "sqlite3" && reqs.any? { |r| r.to_s == "~> 1.4" }
      super(dep, *reqs)
    end
  end)
end
