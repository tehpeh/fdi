require 'bundler/setup'
require 'sinatra'
require 'datamapper'

# models
class Obs
  include DataMapper::Resource
  property :id,                 Serial,   :index => true
  property :time,               DateTime, :required => true
  property :temperature,        Float,    :required => true
  property :drought_factor,     Integer,  :required => true
  property :wind_speed,         Float,    :required => true
  property :relative_humidity,  Float,    :required => true
  property :fdi,                Integer,  :index => true, :writer => :protected
  timestamps :created_at, :updated_at

  before :save, :calculate_fdi

  def self.recalculate_fdis
    Obs.all.each do |o|
      o.calculate_fdi
      o.save
    end
  end

  def calculate_fdi
    self.fdi = ( 7.0 / drought_factor ) *
      ( wind_speed / ( 10 - ( (temperature - relative_humidity) / 4.0))).round.to_i
  end
end
DataMapper.finalize

# lib
def process
  ENV['_'].split('/').last
end

# sinatra
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

# controllers
get '/' do
  content_type :html
  send_file 'public/index.html'
end

get '/obs/?', :provides => :json do
  Obs.all.to_json
end

get '/obs/:id', :provides => :json do
  if obs = Obs.get(params[:id])
    obs.to_json
  else
    status 404
    { :error => 'Not found' }.to_json
  end
end

post '/obs/?', :provides => :json do
  obs = Obs.new(params[:obs])
  if obs.save
    status 201
    headers['Location'] = "/obs/#{obs.id}"
    obs.to_json
  else
    status 400
    obs.errors.to_hash.to_json
  end
end

not_found do
  status 404
  "Not found"
end

error do
  status 500
  "Server error"
end