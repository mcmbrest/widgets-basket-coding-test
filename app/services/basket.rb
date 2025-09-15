# frozen_string_literal: true

class Basket
  def initialize(delivery_rules:, offers:)
    @delivery_rules = delivery_rules
    @offers = offers

    @products = []
  end

  attr_reader :delivery_rules, :offers, :products

  def add(code)
    # Add product to basket
  end

  def total
    # Return total price of basket
  end
end
