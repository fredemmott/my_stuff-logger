# Copyright 2011-present Fred Emmott. See COPYING file.

require 'my_stuff/logger'

module Kernel
  def l *args
    @my_stuff_logger ||= MyStuff::Logger.new
    @my_stuff_logger.raw_log caller, :debug, args
  end
end
