require_relative 'spec_helper'

describe Croupier::GameState do
  describe "#regirster_player" do
    it "should add the player to the list of players" do
      first_player = double("First player")
      second_player = double("Second player")

      game_state = Croupier::GameState.new
      game_state.register_player(first_player)
      game_state.register_player(second_player)

      game_state.players.should == [first_player, second_player]
    end
  end

  describe "#register_spectator" do
    it "should add tge spectator to the list of spectators" do
      spectator = double("Spectator")

      game_state = Croupier::GameState.new
      game_state.register_spectator(spectator)

      game_state.spectators.should == [spectator]
    end
  end

  describe "#send_message_to_everyone" do
    it "should send the messages to each player" do
      game_state = SpecHelper::MakeGameState.with players: [double("First player"), double("Second player")]

      game_state.players.each do |player|
        player.should_receive(:the_message)
      end

      game_state.each_observer do |observer|
        observer.the_message
      end
    end

    it "should send the messages to all spectators" do
      game_state = SpecHelper::MakeGameState.with spectators: [double("First spectator"), double("Second spectator")]

      game_state.spectators.each do |spectator|
        spectator.should_receive(:the_message)
      end

      game_state.each_observer do |observer|
        observer.the_message
      end
    end
  end

  describe "#send_message_to_spectators" do
    it "should not send the messages to the players" do
      game_state = SpecHelper::MakeGameState.with players: [double("First player"), double("Second player")]

      game_state.each_spectator do |observer|
        observer.the_message
      end
    end

    it "should send the messages to all spectators" do
      game_state = SpecHelper::MakeGameState.with(
          players: [double("First player"), double("Second player")],
          spectators: [double("First spectator"), double("Second spectator")]
      )

      game_state.spectators.each do |spectator|
        spectator.should_receive(:the_message)
      end

      game_state.each_spectator do |observer|
        observer.the_message
      end
    end
  end

  describe "#transfer_bet" do
    it "should transfer the amount requested from the player to the pot, and notify observers" do
      strategy = double("player strategy")
      game_state = SpecHelper::MakeGameState.with players: [Croupier::Player.new(Croupier::PlayerStrategy.new(strategy, nil))]
      strategy.should_receive(:name).and_return("Joe")

      bet = API::Bet.new
      bet.amount = 40
      bet.type = API::BetType::Raise

      competitor = API::Competitor.new
      competitor.name = "Joe"
      competitor.stack = 960

      strategy.should_receive(:bet).with(competitor, bet)

      game_state.transfer_bet game_state.players.first, 40, :raise

      game_state.players.first.stack.should == 960
      game_state.pot.should == 40
    end
  end

  context "iterators" do
    before :each do
      @game_state = SpecHelper::MakeGameState.with(
          players: [fake_player, fake_player],
          spectators: [SpecHelper::FakeSpectator.new, SpecHelper::FakeSpectator.new]
      )
    end

    describe "#each_player" do
      it "should yield each player" do
        players = []
        @game_state.each_player do |player|
          players << player
        end

        players.should == @game_state.players
      end
    end
    
    describe "#each_spectator" do
      it "should yield each spectator" do
        spectators = []
        @game_state.each_spectator do |spectator|
          spectators << spectator
        end

        spectators.should == @game_state.spectators
      end
    end
    
    describe "#each_player_and_spectator" do
      it "should yield each player and spectator" do
        observers = []
        @game_state.each_observer do |observer|
          observers << observer
        end

        observers.should == @game_state.players + @game_state.spectators
      end
    end
  end

end