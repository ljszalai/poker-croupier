$:.push(File.join(File.dirname(__FILE__), '../common/lib'))

require 'thrift_builder'
require_relative 'json_spectator'

ThriftBuilder.server(API::Spectator::Processor, JsonSpectator::Handler, ARGV.first).serve()