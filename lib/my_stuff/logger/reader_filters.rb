# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/logger/reader_filter'

module MyStuff::Logger
  module ReaderFilters
    {
      :PriorityColors      => 'priority_colors',
      :TailFollowHighlight => 'tail_follow_highlight',
      :MultiDBUnmangle     => 'multidb_unmangle',
    }.each do |sym, file|
      autoload sym, "my_stuff/logger/reader_filters/#{file}"
    end
  end
end
