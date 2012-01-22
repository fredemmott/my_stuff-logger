require 'rubygems'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

# I'm not using the Gem/PackageTask as I'm strongly of the opinion that
# 'gem build *.gemspec' should work.
task :gem => :test do
  system 'gem build my_stuff-logger.gemspec'
end

task :test => :spec
task :default => :gem
