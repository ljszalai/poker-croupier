
module Ranking
  module HandType
    class FourOfAKind < Base

      def handles?
        n_of_a_kind? 4
      end

      def number_of_kickers
        1
      end

      def rank
        7
      end

      def value
        highest_same_value 4
      end

      #because the kicker could be part of a pair
      def kickers
        [[super,highest_same_value_except(2,value)].flatten.max]
      end

    end
  end
end
