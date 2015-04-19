$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "ohm"
require 'ohm/set'
require 'ohm/pop'

RSpec.configure do |config|
  config.before do
    Ohm.flush
  end
end
