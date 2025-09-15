# frozen_string_literal: true

class Basket
  class Error < StandardError; end

  def initialize(delivery_rules:, offers:)
    @delivery_rules = delivery_rules
    @offers = offers

    @products = []
  end

  attr_reader :delivery_rules, :offers, :products

  def add(code)
    product = Product.find_by(code:)
    raise Error, "Product not found" unless product

    @products << product.code
  end

  def total
    # Return total price of basket
  end
end
