# frozen_string_literal: true

class DeliveryProviders::Default < DeliveryProviders::Base
  def calculate
    case basket.subtotal
    when 0...50
      4.95
    when 50...90
      2.95
    when (90..)
      0
    else
      raise Basket::Error, "Invalid subtotal price"
    end
  end
end
