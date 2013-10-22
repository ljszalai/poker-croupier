$:.push(File.join(File.dirname(__FILE__), 'lib/api'))
$:.push(File.join(File.dirname(__FILE__)))

require 'thrift'
require 'spectator'
require 'json_spectator'

# sinatra
#require "rubygems"
#require "bundler/setup"
require 'sinatra'

module JsonSpectator

  autoload :Handler, 'lib/handler'

  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end

# get '/players' do
#   "hello"
# end

# Sinatra::Application