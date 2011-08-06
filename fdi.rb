require 'bundler/setup'
require 'sinatra'
require 'datamapper'

class Obs
  include DataMapper::Resource
  property :id,         Serial
  property :time,       DateTime, :required => true
  timestamps :created_at, :updated_at
end
DataMapper.finalize

def process
  ENV['_'].split('/').last
end

configure :development do
  require 'sinatra/reloader'
  DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db/fdi_development.sqlite3")
  unless process == 'rake'
    DataMapper::Logger.new($stdout, :debug)
    DataMapper.auto_upgrade!
  end
end

configure :test do
  DataMapper.setup(:default, 'sqlite::memory:')
end

get '/' do
  status 200
end