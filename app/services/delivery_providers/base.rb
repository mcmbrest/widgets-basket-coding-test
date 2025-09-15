# frozen_string_literal: true

class DeliveryProviders::Base
  def initialize(basket:)
    @basket = basket
  end

  attr_reader :basket

  def calculate
    raise NotImplementedError
  end

  # TODO: Add here delivery time calculation
end
