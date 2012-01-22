# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/logger/levels'

module MyStuff
  module Logger
    class Writer
      # Configure the logger.
      #
      # These can be set:
      # - globally, via Writer.option = foo
      # - per-class, via Writer.new(:option => foo)
      # - per class, via Writer.new.option = foo
      OVERRIDABLE_OPTIONS = [
        :backtrace_level,
        :device,
        :level,
        :root_path,
      ]
      attr_writer *OVERRIDABLE_OPTIONS

      def initialize options = {}
        OVERRIDABLE_OPTIONS.each do |opt|
          if options.include? opt
            instance_variable_set "@#{opt}", options[opt]
          end
        end
      end

      def raw_log outer_caller, level, args

        unless LEVELS.include? level
          raw_log outer_caller, :fatal, "%s (unknown level '%s')" % [log_text(*args), level.inspect]
        end

        return if LEVELS[level] < LEVELS[self.level]

        message  = "%s %s @%s> %s\n" % [
          level.to_s[0,1].upcase, # D|I|W|E|F
          Time.new.strftime("%s [%Y-%m-%d %H:%M:%S %z]"),
          pretty_caller(outer_caller.first),
          log_text(*args)
        ]

        if LEVELS[level] >= LEVELS[self.backtrace_level]
          # Full backtrace
          outer_caller.each do |x|
            message += "  from %s\n" % pretty_caller(x)
          end
        end

        device.write message
      end

      LEVELS.each do |level,i|
        define_method level do |*args|
          raw_log caller, level, args
        end
      end

      OVERRIDABLE_OPTIONS.each do |opt|
        define_method opt do
          instance_variable_get("@#{opt}") || MyStuff::Logger.send(opt)
        end
      end

      private

      def log_text *args
        args.map do |arg|
          case arg
          when String
            arg
          else
            arg.inspect
          end
        end.join('')
      end

      def pretty_caller x
        x.sub(root_path + '/', '').sub(/^.\//, '')
      end
    end
  end
end
