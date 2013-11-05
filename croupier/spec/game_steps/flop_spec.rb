require_relative '../spec_helper.rb'



describe Croupier::GameSteps::DealFlop do
  def run
    Croupier::GameSteps::DealFlop.new(@game_state).run
  end

  before(:each) do
    @cards = ['6 of Diamonds', 'Jack of Hearts', 'Ace of Spades', 'King of Clubs'].map { |name| Card.new name }

    @deck = double("Deck")
    @deck.stub(:next_card!).and_return(*@cards)

    Croupier::Deck.stub(:new).and_return(@deck)

    @game_state = SpecHelper::MakeGameState.with(
          players: [fake_player, fake_player],
          spectators: [SpecHelper::FakeSpectator.new, SpecHelper::FakeSpectator.new]
    )
  end

  it "should deal three community cards and notify the players" do
    @game_state.players.each do |player|
      @cards[0..2].each do |card|
        player.should_receive(:community_card).with(card)
      end
    end

    run
  end

  it "should deal three community cards and notify the spectators" do
    @game_state.spectators.each do |spectator|
      @cards[0..2].each do |card|
        spectator.should_receive(:community_card).with(card)
      end
    end

    run
  end
end
