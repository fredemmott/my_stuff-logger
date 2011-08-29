require 'cucumber/rake/task'

task :default => :gem

Cucumber::Rake::Task.new(:test)

# I'm not using the Gem/PackageTask as I'm strongly of the opinion that
# 'gem build *.gemspec' should work.
task :gem => :test do
  system 'gem build my_stuff-logger.gemspec'
end
