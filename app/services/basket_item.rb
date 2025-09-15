# frozen_string_literal: true

class BasketItem
  def initialize(product:, quantity: 1)
    @product = product
    @quantity = quantity

    @applied_offers = []
    @discounted_amount = nil
  end

  attr_reader :product, :applied_offers, :discounted_amount
  attr_accessor :quantity

  def amount
    product.price * quantity
  end

  def basket_amount
    discounted_amount || amount
  end

  def add_offer(offer:, discounted_amount:)
    @discounted_amount = discounted_amount
    @applied_offers << offer unless applied_offers.include?(offer)
  end
end
