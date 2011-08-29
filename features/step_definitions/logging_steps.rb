Given /^a MyStuff::Logger/ do
  @root = File.expand_path(File.dirname(__FILE__) + '/../..')
  @device  = StringIO.new
  @context = MyStuff::Logger.new(
    :device    => @device,
    :root_path => @root
  )
end

Given /^a level of :([a-z]+)$/ do |level|
  @context.level = level.to_sym
end

Given /^a backtrace level of :([a-z]+)$/ do |level|
  @context.backtrace_level = level.to_sym
end

When /^I log a :([a-z]+) entry$/ do |level|
  @message = rand.to_s
  @aborted = false
  @bt      = caller

  @when    = Time.new.to_i

  @bt.shift # includes line number within 'When', not going to happen
  @context.send level.to_sym, @message
end

Then /^I should get no output$/ do
  @device.string.should be_empty
end

Then /^I should get.+(lines?)$/ do |mode|
  mode = mode == 'lines' ? :multi : :single
  @result = @device.string

  # preprocessing for the rest, not part of this test
  lines = @result.split("\n")
  if mode == :single
    lines.count.should == 1
  else
    lines.count.should >= 2
  end

  @first = lines.shift
  @rest  = lines
end

Then /^(?:it|the first) should begin with '([A-Z])'$/ do |prefix|
  @first[0].should == prefix
end

Then /^it should include the current timestamp$/ do
  @first.index(@when.to_s).should_not be_nil
end

Then /^it should include the caller$/ do
  @first.index(File.expand_path(__FILE__).sub("#{@root}/", '')).should_not be_nil
end

Then /^it should include the message$/ do
  @first.index(@message).should_not be_nil
  @first.index("\"#{@message}\"").should be_nil # 'inspect' getting called inappropraitely
end

Then /^it should include '([^']+)'$/ do |text|
  @first.index(text).should_not be_nil
end

Then /^the rest should (?:include|be) a backtrace$/ do
  # The backtrace gets prettied a bit... be liberal.
  @bt.all?{|i| @rest.any?{|j| j.index i.sub(@root, '')}}.should be_true
end

Then /^the backtrace should not include '([^']+)'$/ do |must_omit|
  @rest.any?{ |i| i.sub(@root, '').index must_omit }.should be_false
end
