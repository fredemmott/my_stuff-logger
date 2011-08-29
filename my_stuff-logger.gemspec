# -*- encoding: utf-8 -*-
require 'rake'

Gem::Specification.new do |s|
  s.name          = 'my_stuff-logger'
  s.version       = '0.0.1'
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Fred Emmott']
  s.email         = ['mail@fredemmott.co.uk']
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/fredemmott/my_stuff-logger'
  s.summary       = 'Logging class'
  s.description   = ''
  s.license       = 'ISC'
  s.files         = FileList[
    'COPYING',
    'lib/**/*.rb',
  ].to_a
end
