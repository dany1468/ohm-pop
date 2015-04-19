$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "ohm"
require 'ohm/set'
require 'ohm/pop'

RSpec.configure do |config|
  config.before do
    Ohm.flush
    Ohm.redis = Redic.new("redis://#{ENV['WERCKER_REDIS_HOST'] || 'localhost'}:#{ENV['WERCKER_REDIS_PORT'] || 6379}/")
  end
end
