require File.expand_path(File.join(File.dirname(__FILE__), 'fdi'))
DataMapper::Logger.new($stdout, :fatal)

namespace :db do
  desc 'Reset the database'
  task :reset do
    DataMapper.auto_migrate!
  end
  task :hi do
    puts ENV['_']
  end
end

task :console do
  sh "irb -r #{File.expand_path(File.join(File.dirname(__FILE__), 'fdi'))}"
end