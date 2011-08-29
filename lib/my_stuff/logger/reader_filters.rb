# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/logger/reader_filter'

module MyStuff::Logger
  module ReaderFilters
    SYMBOL_MAP =  {
      :PriorityColors      => 'priority_colors',
      :TailFollowHighlight => 'tail_follow_highlight',
      :MultiDBUnmangle     => 'multidb_unmangle',
    }

    SYMBOL_MAP.each do |sym, file|
      autoload sym, "my_stuff/logger/reader_filters/#{file}"
    end

    def self.get filter
      case filter
      when Symbol
        self.get MyStuff::Logger::ReaderFilters.const_get(filter)
      when Class
        filter.to_proc
      end
    end
  end
end
