#
# Autogenerated by Thrift Compiler (0.9.1)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'

module API
  module Suit
    Hearts = 0
    Diamonds = 1
    Spades = 2
    Clubs = 3
    VALUE_MAP = {0 => "Hearts", 1 => "Diamonds", 2 => "Spades", 3 => "Clubs"}
    VALID_VALUES = Set.new([Hearts, Diamonds, Spades, Clubs]).freeze
  end

  module BetType
    Fold = 0
    Check = 1
    Call = 2
    Blind = 3
    Raise = 4
    Allin = 5
    VALUE_MAP = {0 => "Fold", 1 => "Check", 2 => "Call", 3 => "Blind", 4 => "Raise", 5 => "Allin"}
    VALID_VALUES = Set.new([Fold, Check, Call, Blind, Raise, Allin]).freeze
  end

  class Competitor
    include ::Thrift::Struct, ::Thrift::Struct_Union
    NAME = 1
    STACK = 2

    FIELDS = {
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'},
      STACK => {:type => ::Thrift::Types::I64, :name => 'stack'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Card
    include ::Thrift::Struct, ::Thrift::Struct_Union
    VALUE = 1
    SUIT = 2
    NAME = 3

    FIELDS = {
      VALUE => {:type => ::Thrift::Types::I16, :name => 'value'},
      SUIT => {:type => ::Thrift::Types::I32, :name => 'suit', :enum_class => ::API::Suit},
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name'}
    }

    def struct_fields; FIELDS; end

    def validate
      unless @suit.nil? || ::API::Suit::VALID_VALUES.include?(@suit)
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field suit!')
      end
    end

    ::Thrift::Struct.generate_accessors self
  end

  class Bet
    include ::Thrift::Struct, ::Thrift::Struct_Union
    AMOUNT = 1
    TYPE = 2

    FIELDS = {
      AMOUNT => {:type => ::Thrift::Types::I64, :name => 'amount'},
      TYPE => {:type => ::Thrift::Types::I32, :name => 'type', :enum_class => ::API::BetType}
    }

    def struct_fields; FIELDS; end

    def validate
      unless @type.nil? || ::API::BetType::VALID_VALUES.include?(@type)
        raise ::Thrift::ProtocolException.new(::Thrift::ProtocolException::UNKNOWN, 'Invalid value of field type!')
      end
    end

    ::Thrift::Struct.generate_accessors self
  end

end
