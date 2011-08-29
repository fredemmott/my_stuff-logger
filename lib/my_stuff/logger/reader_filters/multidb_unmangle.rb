# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/multidb'

module MyStuff::Logger::ReaderFilters
  # For use with MyStuff::MultiDB.
  #
  # Your backtrace will include something like:
  #  Foo::MYSTUFF_MULTIDB_DB_load_of_hex::Bar
  # And give you:
  #  Foo::<host:port/database>::Bar
  class MultiDBUnmangle < MyStuff::Logger::ReaderFilter
    def filter_line line, options = {}
      line.gsub(/MYSTUFF_MULTIDB_DB_[a-z0-9]+/) do |mangled|
        data = MyStuff::MultiDB.unmangle(mangled)
        unmangled = "<%s:%d/%s>" % [
          data[:host],
          data[:port],
          data[:database],
        ]
        if options[:colorize]
          # Make it cyan
          "\e[36m%s\e[0m" % unmangled
        else
          unmangled
        end
      end
    end
  end
end
