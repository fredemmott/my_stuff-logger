_FILE = File.expand_path(__FILE__)
_DIR = File.dirname(__FILE__)
_ROOT = File.expand_path(_DIR + '/../../')

$LOAD_PATH.push(_ROOT + '/lib')

require 'my_stuff/logger'

require 'rspec'
