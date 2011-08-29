# Copyright 2011-present Fred Emmott. See COPYING file.

module MyStuff::Logger::ReaderFilters
  # If you actually pipe tail -F through this...
  class TailFollowHighlight < MyStuff::Logger::ReaderFilter
    def filter_line line, options = {}
      if options[:colorize]
        line.sub(/^(tail: .+ new file$)/, "\e[1m\\1\e[0m")
      else
        line
      end
    end
  end
end
