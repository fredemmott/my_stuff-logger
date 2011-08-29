# Copyright 2011-present Fred Emmott. See COPYING file.

module MyStuff::Logger::ReaderFilters
  # Highlight info/warning/error/fatal in different colors.
  class PriorityColors < MyStuff::Logger::ReaderFilter
    def filter_line line, options = {}
     return line unless options[:colorize]

      line = line.dup

      # Colorize, based on priority
      line.sub! /^([IWEF]) ([0-9]+ \[[^>]+>)/ do |prefix|
        # Set the color
        colors = {
                         # debug  => meh
          'I' => '32',   # info   => green
          'W' => '33',   # warn   => yellow
          'E' => '31',   # errror => red
          'F' => '1;31', # fatal  => bold + red
        }
        # Reset it once the standard info is done
        prefix.sub! /^[IWEF]/ do |pri|
          "\e[%sm%s" % [colors[pri], pri]
        end
        prefix.sub! '>', ">\e[0m"
        prefix
      end
      line
    end
  end
end
