# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/logger/levels'
require 'my_stuff/logger/reader_filters'

module MyStuff::Logger
  class Reader
    attr_accessor :filters
    attr_reader :output
    def colorize?; @colorize; end

    def initialize options = {}
      @output = options[:device] || STDOUT
      if options.include? :colorize
        @colorize = options[:colorize]
      else
        @colorize = @output.tty?
      end

      @filters = (options[:filters] || [
        :PriorityColors,
      ]).map{ |filter| ReaderFilters.get(filter) }
    end

    # Read lines from IO, and pretty-print them.
    def format_io input
      input.each_line do |line|
        output.write format_log_line(line)
      end
    end

    def format_log_line x
      filters.each do |filter|
        x.replace(filter.call(x, :colorize => colorize?))
      end
      x
    end

    # Do a *really* poor job of emulating an IO device :p
    def write x
      x.each_line do |line|
        output.write format_log_line(line)
      end
    end
  end
end
