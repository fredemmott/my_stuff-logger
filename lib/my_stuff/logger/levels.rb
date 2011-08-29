# Copyright 2011-present Fred Emmott. See COPYING file.

module MyStuff
  module Logger
    LEVELS = {
      :debug   => 0,
      :info    => 1,
      :warn    => 2,
      :error   => 3,
      :fatal   => 4,
      :disable => 0xffffff
    }
  end
end
