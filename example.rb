#!/usr/bin/env ruby
# Copyright 2011-present Fred Emmott. See COPYING file.

_DIR = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.push(File.join(_DIR, 'lib'))

require 'optparse'

options = {}

optparse = OptionParser.new do |opts|
  opts.on(
    '--level=debug|info|warn|error|fatal|disable',
    'What level of output to show',
    /^debug|info|warn|error|fatal|disable$/
  ) do |level|
    options[:level] = level.to_sym
  end

  opts.on(
    '--backtrace-level=debug|info|warn|error|fatal|disable',
    'What level of output to show backtraces for',
    /^debug|info|warn|error|fatal|disable$/
  ) do |level|
    options[:backtrace_level] = level.to_sym
  end

  opts.on(
    '--colors=yes|no|auto',
    'Colorize output',
    /^yes|no|auto$/
  ) do |value|
    case value
    when 'yes'
      options[:colorize] = true
    when 'no'
      options[:colorize] = false
    end
  end
end
optparse.parse!

require 'my_stuff/logger'
require 'my_stuff/logger/reader'

require 'logger' # Ruby's standard one

MyStuff::Logger.level = options[:level]
MyStuff::Logger.backtrace_level = options[:backtrace_level]

# We set the output device of the logger to be the reader.
# This gives us rainbows and unicorns — well, colourized output at least.
reader = MyStuff::Logger::Reader.new(options)
options[:device] = reader
logger = MyStuff::Logger.new(options)

def compare logger
  puts '=== Comparison ==='
  Logger.new(STDOUT).error "This is Ruby's standard Logger"
  logger.error "This is MyStuff::Logger"
end

def spam logger
  puts '=== Spamming All Log Levels ==='
  logger.debug 'nyan nyan nyan'
  logger.info ({:what => 'cool story bro'})
  logger.warn "IMA CHARGIN' MAH LAZER"
  logger.error "Somebody set us up the bomb"
  logger.fatal "No more kitten pictures."
end

l 'Debug statement'
compare logger
spam logger
