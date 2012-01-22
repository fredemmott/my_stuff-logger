require 'rubygems'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

gemspec = Gem::Specification.new do |s|
  s.name          = 'my_stuff-logger'
  s.version       = '0.1.0'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Fred Emmott']
  s.email         = ['mail@fredemmott.co.uk']
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/fredemmott/my_stuff-logger'
  s.summary       = 'Logging class'
  s.license       = 'ISC'
  s.files         = Dir[
    'COPYING',
    'README.rdoc',
    'example.rb',
    'lib/**/*.rb',
  ]
end
Gem::PackageTask.new(gemspec) do |pkg|
  pkg.need_tar = true
end

task :test => :spec
task :default => [:package, :test]
