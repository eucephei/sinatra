require File.join(File.dirname(__FILE__), '..', 'main')
require 'spec'
require 'spec/interop/test'
require 'rack/test'

Test::Unit::TestCase.send :include, Rack::Test::Methods

# Set the Sinatra environment
set :environment, :test

# Add an app method for RSpec
def app
  Sinatra::Application
end
