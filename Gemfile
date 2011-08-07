source :rubygems

gem 'sinatra',    '~> 1.2.6'
gem 'datamapper', '~> 1.1.0'
gem 'thin',       '~> 1.2.11'

group :production do
  #gem 'pg', '~> 0.11.0'
  gem 'dm-postgres-adapter', '~> 1.1.0'
end

group :development, :test do
  gem 'dm-sqlite-adapter', '~> 1.1.0'
  gem 'rake',              '0.8.7'
  gem 'heroku',            '>= 2.1.0'
  gem 'sinatra-reloader'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'growl'
  # group :test do
  gem 'rack-test'
  gem 'rspec'
end