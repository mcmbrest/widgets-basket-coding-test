# frozen_string_literal: true

RSpec.describe DeliveryProviders::Default do
  def basket_with_subtotal(value)
    instance_double('Basket', items: [
      instance_double('BasketItem', basket_amount: value)
    ])
  end

  it 'returns 4.95 when subtotal is less than 50' do
    basket = basket_with_subtotal(49.99)
    provider = described_class.new(basket: basket)

    expect(provider.calculate).to eq(4.95)
  end

  it 'returns 2.95 when subtotal is between 50 and 90' do
    basket = basket_with_subtotal(50.00)
    provider = described_class.new(basket: basket)

    expect(provider.calculate).to eq(2.95)
  end

  it 'returns 0 when subtotal is 90 or more' do
    basket = basket_with_subtotal(90.00)
    provider = described_class.new(basket: basket)

    expect(provider.calculate).to eq(0)
  end

  it 'raises Basket::Error for invalid subtotal (e.g., negative)' do
    basket = basket_with_subtotal(-1)
    provider = described_class.new(basket: basket)

    expect { provider.calculate }.to raise_error(Basket::Error, 'Invalid subtotal price')
  end
end
