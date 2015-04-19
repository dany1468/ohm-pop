$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require "ohm"
require 'ohm/set'
require 'ohm/pop'

RSpec.configure do |config|
  config.before :all do
    Ohm.redis = Redic.new("redis://#{ENV['WERCKER_REDIS_HOST'] || 'localhost'}:#{ENV['WERCKER_REDIS_PORT'] || 6379}/")
  end

  config.before do
    Ohm.flush
  end
end
