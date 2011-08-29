Feature: logging system
  Scenario: debug log is disabled by default
    Given a MyStuff::Logger
    When I log a :debug entry
    Then I should get no output

	Scenario: debug log is explicitly enabled
		Given a MyStuff::Logger
    And a level of :debug
		When I log a :debug entry
		Then I should get a single line
		And it should begin with 'D'
		And it should include the current timestamp
		And it should include the caller
    And it should include the message

	Scenario: info log
		Given a MyStuff::Logger
		When I log a :info entry
		Then I should get a single line
		And it should begin with 'I'
		And it should include the current timestamp
		And it should include the caller
		And it should include the message

	Scenario: warn log
		Given a MyStuff::Logger
		When I log a :warn entry
		Then I should get a single line
		And it should begin with 'W'
		And it should include the current timestamp
		And it should include the caller
		And it should include the message

	Scenario: error log
		Given a MyStuff::Logger
		When I log a :error entry
		Then I should get multiple lines
		And the first should begin with 'E'
		And it should include the current timestamp
		And it should include the caller
		And it should include the message
		And the rest should be a backtrace
		And the backtrace should not include 'raw_log'
		And the backtrace should not include 'error'

	Scenario: fatal log
		Given a MyStuff::Logger
		When I log a :fatal entry
		Then I should get multiple lines
		And the first should begin with 'F'
		And it should include the current timestamp
		And it should include the caller
		And it should include the message
		And the rest should be a backtrace
		And the backtrace should not include 'raw_log'
    And the backtrace should not include 'fatal'

	Scenario: debug set to backtrace
    Given a MyStuff::Logger
    And a level of :debug
    And a backtrace level of :debug
		When I log a :debug entry
		Then I should get multiple lines
		And the first should begin with 'D'
		And it should include the current timestamp
		And it should include the caller
		And it should include the message
		And the rest should be a backtrace
		And the backtrace should not include 'raw_log'
    And the backtrace should not include 'debug'

  Scenario: can suppress everything
    Given a MyStuff::Logger
    And a level of :disable
    When I log a :fatal entry
    And I log a :warn entry
    Then I should get no output

  Scenario: can suppress backtraces
    Given a MyStuff::Logger
    And a backtrace level of :disable
    When I log a :fatal entry
    Then I should get a single line
