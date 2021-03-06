require_relative '../spec_helper'


describe Croupier::GameSteps::BettingStep do
  before :each do
    @spectator = SpecHelper::FakeSpectator.new
    @player1 = Croupier::Player.new SpecHelper::FakeStrategy.new

    @game_state = SpecHelper::MakeGameState.with players: [@player1], spectators: [@spectator]
  end

  def should_bet(player, amount, type)
    player.should_receive(:bet_request).and_return(amount)
    @spectator.should_receive(:bet).with(player, amount: amount, type: type)
  end

  def run()
    Croupier::GameSteps::BettingStep.new(@game_state).run
  end

  it "should request a bet from the player in action, and the player should remain active" do
    should_bet(@player1, 0, :check)
    run
    @player1.active?.should == true
  end

  it "should transfer a non zero bet to the pot" do
    should_bet @player1, 20, :raise
    run
    @game_state.pot.should == 20
    @player1.stack.should == 980
  end

  context "at least two players" do

    before :each do
      @player2 = Croupier::Player.new SpecHelper::FakeStrategy.new
      @game_state.register_player @player2
    end

    it "should ask the second player after the first player" do
      should_bet @player1, 0, :check
      should_bet @player2, 0, :check
      run
    end

    it "should transfer non zero bets to the pot" do
      should_bet @player1, 20, :raise
      should_bet @player2, 20, :call
      run
      @game_state.pot.should == 40
      @player1.stack.should == 980
      @player2.stack.should == 980
    end

    it "should ask the first player again if the second raises" do
      should_bet @player1, 20, :raise
      should_bet @player2, 40, :raise
      should_bet @player1, 20, :call
      run
      @game_state.pot.should == 80
      @player1.stack.should == 960
      @player2.stack.should == 960
    end

    it "should interpret a zero bet after a raise as a fold" do
      should_bet @player1, 20, :raise
      should_bet @player2, 0, :fold
      run
      @game_state.pot.should == 20
    end

    it "should mark a folded player inactive" do
      should_bet @player1, 20, :raise
      should_bet @player2, 0, :fold
      run
      @player2.active?.should == false
    end

    it "should keep track of the total_bet for each player" do
      should_bet @player1, 20, :raise
      should_bet @player2, 0, :fold
      run
      @player1.total_bet.should == 20
      @player2.total_bet.should == 0
    end

    it "should interpret a bet smaller then the previous raise as a fold" do
      should_bet @player1, 20, :raise

      @player2.should_receive(:bet_request).and_return(19)
      @spectator.should_receive(:bet).with(@player2, amount: 0, type: :fold)

      run
      @game_state.pot.should == 20
      @player2.stack.should == 1000

      @player2.total_bet.should == 0
    end

    it "should skip inactive players" do
      @player3 = Croupier::Player.new SpecHelper::FakeStrategy.new
      @game_state.register_player @player3

      should_bet @player1, 20, :raise
      should_bet @player2, 0, :fold
      should_bet @player3, 40, :raise
      should_bet @player1, 20, :call
      run
    end


    context "player has less money then needed to call" do
      before :each do
        @player2.stack = 20
        should_bet @player1, 100, :raise
      end

      it "should let a player go all in" do
        should_bet @player2, 20, :allin

        run

        @player2.stack.should == 0
        @player2.total_bet.should == 20

        @game_state.pot.should == 120
      end

      it "should treat larger bet as an all in" do
        @player2.should_receive(:bet_request).and_return(40)
        @spectator.should_receive(:bet).with(@player2, amount: 20, type: :allin)

        run

        @player2.stack.should == 0
        @player2.total_bet.should == 20

        @game_state.pot.should == 120

      end
    end

  end

end
