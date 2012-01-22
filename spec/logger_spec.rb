require 'spec_helper'

describe MyStuff::Logger do
  before :each do
    @root = File.expand_path(File.dirname(__FILE__) + '/..')
    @stringio = StringIO.new
    @logger = MyStuff::Logger.new(
      :device => @stringio,
      :root_path => @root
    )
  end

  shared_examples_for 'an enabled logger' do
    before :each do
      @message = 'herpityderpirty' + rand.to_s
      @logger.send level, @message
    end

    it 'should output something' do
      @stringio.string.should_not be_empty
    end

    it 'should include the message' do
      @stringio.string.should include @message
    end

    it 'should include the current unix timestamp' do
      @stringio.string.should include Time.new.to_i.to_s
    end

    it 'should start with a single-character level indication' do
      indicator = level.to_s[0,1].upcase
      @stringio.string.should match /^#{indicator}/
    end

    it 'should include the caller' do
      # '@' is shorthand here for root
      @stringio.string.should match %r{@spec/logger_spec.rb:[0-9]+:}
    end

    it 'should trim the root path from the caller' do
      @stringio.string.should_not include @root
    end
  end

  shared_examples_for 'a single-line logger' do
    before :each do
      @message = 'herpityderpirty' + rand.to_s
      @logger.send level, @message
    end

    it_behaves_like 'an enabled logger'

    it 'should output a single line' do
      @stringio.string.strip.split("\n").count.should == 1
    end
  end

  shared_examples_for 'a backtracing logger' do
    before :each do
      @message = 'herpityderpirty' + rand.to_s
      @bt = caller
      @logger.send level, @message
    end

    it_behaves_like 'an enabled logger'

    it 'should include multiple lines' do
      @stringio.string.strip.split("\n").count.should be > 1
    end

    it 'should include a backtrace' do
      @stringio.string.should include @bt[2]
    end

    context 'the backtrace' do
      it 'should not not include "raw_log"' do
        @stringio.string.should_not include 'raw_log'
      end

      it 'should not include the level' do
        lines = @stringio.string.split("\n")[1..-1]
        lines.should_not include level.to_s
      end
    end
  end

  it 'should ignore debug logs by default' do
    @logger.debug 'foo'
    @stringio.string.should be_empty
  end

  context 'with level set to :debug' do
    before :each do
      @logger.level = :debug
    end

    context 'debug messages' do
      it_should_behave_like 'a single-line logger' do
        let(:level){:debug}
      end
    end
  end

  context 'info messages' do
    it_should_behave_like 'a single-line logger' do
      let(:level){:info}
    end
  end

  context 'warning messages' do
    it_should_behave_like 'a single-line logger' do
      let(:level){:warn}
    end
  end

  context 'error messages' do
    it_should_behave_like 'a backtracing logger' do
      let(:level){:error}
    end
  end

  context 'with a backtrace level of :debug' do
    context 'debug messages' do
      before :each do
        @logger.level = :debug
        @logger.backtrace_level = :debug
      end

      it_should_behave_like 'a backtracing logger' do
        let(:level){:debug}
      end
    end
  end

  context 'with level set to :disable' do
    before :each do
      @logger.level = :disable
    end

    it 'should even output fatals' do
      @logger.fatal 'foo'
      @stringio.string.should be_empty
    end
  end

  context 'with backtrace_level set to :disable' do
    before :each do
      @logger.backtrace_level = :disable
    end

    context 'fatal messages' do
      it_should_behave_like 'a single-line logger' do
        let(:level){:fatal}
      end
    end
  end
end
