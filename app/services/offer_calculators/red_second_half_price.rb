# frozen_string_literal: true

# Calculates the "Red Widget Second Half Price" offer
# For every second Red Widget (R01) in the basket, its price is reduced by 50%

class OfferCalculators::RedSecondHalfPrice < OfferCalculators::Base
  OFFER_CODE = 'rhp'.freeze

  def apply
    return if red_widget.nil? || red_widget.quantity <= 1

    red_widget.add_offer(offer: OFFER_CODE, discounted_amount:)
  end

  private

  def red_widget
    @_red_widget ||= basket.items.find { |item| item.product.code == 'R01' }
  end

  def discounted_amount
    amount = 0

    (1..red_widget.quantity).each do |i|
      if i % 2 == 0
        amount += (red_widget.product.price / 2).round(2)
      else
        amount += red_widget.product.price
      end
    end

    amount
  end
end
