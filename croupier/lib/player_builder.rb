require 'player_strategy'

class Croupier::PlayerBuilder

  def build_player(host, port)
    Croupier::Player.new(Croupier::PlayerStrategy.new(*build_strategy(host, port)))
  end

  private

  def build_strategy(host, port)
    transport = Thrift::BufferedTransport.new(Thrift::Socket.new(host, port))
    protocol = Thrift::BinaryProtocol.new(transport)
    strategy = API::PlayerStrategy::Client.new(protocol)
    [strategy, transport]
  end
end