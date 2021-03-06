require_relative "spec_helper"

describe "Straight Flush" do
  it 'should rank a straight flush over four of a kind' do
    hand('10 of Spades', 'Jack of Spades', 'Queen of Spades', 'King of Spades', 'Ace of Spades').
        should_defeat hand('Jack of Diamonds', 'Jack of Hearts', 'Jack of Spades', 'Jack of Clubs', 'Queen of Hearts')
  end

  it 'should rank a higher straight flush higher' do
    hand('10 of Spades', 'Jack of Spades', 'Queen of Spades', 'King of Spades', 'Ace of Spades').
      should_defeat hand('9 of Spades', '10 of Spades', 'Jack of Spades', 'Queen of Spades', 'King of Spades')
  end

  it 'should not recognize a straight and a flush as a straight flush' do
    hand('Jack of Diamonds', 'Jack of Hearts', 'Jack of Spades', 'Jack of Clubs', 'Queen of Hearts').
    should_defeat hand('6 of Spades','10 of Spades', 'Jack of Spades', 'Queen of Spades', 'King of Spades', 'Ace of Hearts')
  end

  it 'should ignore extra high cards from a straight flush' do
    hand('4 of Spades', '5 of Spades', '6 of Spades', '7 of Spades', '8 of Spades', 'Queen of Spades').
    should_defeat hand('3 of Spades', '4 of Spades', '5 of Spades', '6 of Spades', '7 of Spades', 'King of Spades')
  end


end
