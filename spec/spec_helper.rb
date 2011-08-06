ENV['RACK_ENV'] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'fdi'))
require 'rack/test'
require 'rspec'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before(:each) { DataMapper.auto_migrate! }
end

def app
  Sinatra::Application
end