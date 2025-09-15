# frozen_string_literal: true

class Basket
  class Error < StandardError; end

  # @param delivery_provider [String, nil] 'pickup' | 'default'
  # @param offers [String, nil] 'rhp'
  def initialize(delivery_provider: nil, offers: nil)
    @delivery_provider = delivery_provider
    @offers = offers || []

    @items = []
  end

  attr_reader :delivery_provider, :offers, :items

  def add_item(code)
    product = Product.find_by(code:)
    raise Error, "Product not found" unless product

    existing_item = items.find { |item| item.product.code == product.code }
    if existing_item
      existing_item.quantity += 1
    else
      @items << BasketItem.new(product:)
    end

    apply_offers
    items
  end

  def add_offer(code)
    @offers << code unless offers.include?(code)
    apply_offers
    offers
  end

  def total
    total = items.sum(&:basket_amount)
    (total + delivery_cost).round(2)
  end

  private

  def apply_offers
    offers.each do |offer|
      Offer.new(basket: self, offer:).apply
    end
  end

  def delivery_cost
    Delivery.new(basket: self, provider: delivery_provider).calculate
  end
end
