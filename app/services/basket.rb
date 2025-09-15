# frozen_string_literal: true

class Basket
  class Error < StandardError; end

  # @param delivery_provider [String, nil] 'pickup' | 'default'
  def initialize(delivery_provider: nil, offers: nil)
    @delivery_provider = delivery_provider
    @offers = offers

    @products = []
  end

  attr_reader :delivery_provider, :offers, :products

  def add(code)
    product = Product.find_by(code:)
    raise Error, "Product not found" unless product

    @products << product
  end

  def subtotal
    products.sum(:price)
  end

  def total
    subtotal + delivery_cost
  end

  private

  def delivery_cost
    Delivery.new(basket: self, provider: delivery_provider).calculate
  end
end
