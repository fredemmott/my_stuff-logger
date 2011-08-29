# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/logger/writer'

module MyStuff
  module Logger
    class <<self
      def new *args
        MyStuff::Logger::Writer.new *args
      end

      attr_writer :device, :level, :backtrace_level, :root_path

      def device
        @device ||= STDOUT
      end

      def level
        @level ||= :info
      end

      def backtrace_level
        @backtrace_level ||= :error
      end

      def root_path
        @root_path ||= File.dirname(File.expand_path($0))
      end
    end
  end
end
