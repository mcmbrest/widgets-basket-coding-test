# frozen_string_literal: true

class OfferCalculators::Base
  def initialize(basket:)
    @basket = basket
  end

  attr_reader :basket

  def apply
    raise NotImplementedError
  end
end
