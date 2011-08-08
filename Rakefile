require File.expand_path(File.join(File.dirname(__FILE__), 'fdi'))

namespace :db do
  desc 'Reset the database'
  task :reset do
    DataMapper.auto_migrate!
  end
  desc 'Auto migrate the database'
  task :upgrade do
    DataMapper.auto_upgrade!
  end
end

desc 'Open an irb session'
task :console do
  sh "irb -r #{File.expand_path(File.join(File.dirname(__FILE__), 'fdi'))}"
end