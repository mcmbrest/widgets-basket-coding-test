# frozen_string_literal: true

  class Offer
    class Error < StandardError; end

    def initialize(basket:, offer:)
      @basket = basket
      @offer = offer
    end

    attr_reader :basket, :offer

    def apply
      offer_calculator.new(basket:).apply
    end

    private

    def offer_calculator
      case offer
      when 'rhp' # Code for Red Second Half Price offer
        OfferCalculators::RedSecondHalfPrice
      else
        raise Error, "Unknown offer: #{offer}"
      end
    end
  end
