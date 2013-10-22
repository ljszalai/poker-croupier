
class JsonSpectator::Handler
  def name
    "Json"
  end

  def competitor_status(competitor)
    JsonSpectator.logger.info "#{competitor.name} has #{competitor.stack} chips"
  end

  def hole_card(competitor, card)
    JsonSpectator.logger.info "#{competitor.name} got hole card #{card.name} (#{card.value}, #{card.suit})"
  end

  def community_card(card)
    JsonSpectator.logger.info "community card #{card.name}"
  end

  def bet(competitor, bet)
    JsonSpectator.logger.info "#{competitor.name} made a bet of #{bet.amount} (#{API::BetType::VALUE_MAP[bet.type]}) and is left with #{competitor.stack} chips"
  end
end