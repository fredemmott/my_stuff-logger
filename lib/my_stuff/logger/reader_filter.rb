# Copyright 2011-present Fred Emmott. See COPYING file.

module MyStuff::Logger
  class ReaderFilter
    def filter_line line, options = {}
      raise NotImplementedError.new
    end

    def self.to_proc
      lambda { |*args| self.new.filter_line *args }
    end
  end
end
