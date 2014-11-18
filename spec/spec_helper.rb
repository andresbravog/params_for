# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'params_validator'
require 'rspec'
require 'pry'

# Requires support files
Dir[File.join(File.dirname(__FILE__), 'shared/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
end
