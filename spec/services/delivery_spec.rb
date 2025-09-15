# frozen_string_literal: true

RSpec.describe Delivery do
  let(:basket) { instance_double('Basket') }

  it 'returns 0 when provider is nil' do
    delivery = Delivery.new(basket: basket, provider: nil)
    expect(delivery.calculate).to eq(0)
  end

  it "uses Pickup provider when provider is 'pickup'" do
    delivery = Delivery.new(basket: basket, provider: 'pickup')

    provider_double = instance_double('DeliveryProviders::Pickup', calculate: 0.0)
    expect(DeliveryProviders::Pickup).to receive(:new).with(basket: basket).and_return(provider_double)
    expect(delivery.calculate).to eq(0.0)
  end

  it "uses Default provider when provider is 'default'" do
    delivery = Delivery.new(basket: basket, provider: 'default')

    provider_double = instance_double('DeliveryProviders::Default', calculate: 2.95)
    expect(DeliveryProviders::Default).to receive(:new).with(basket: basket).and_return(provider_double)
    expect(delivery.calculate).to eq(2.95)
  end

  it 'raises error for unknown provider' do
    delivery = Delivery.new(basket: basket, provider: 'xyz')
    expect { delivery.calculate }.to raise_error(Delivery::Error, 'Unknown delivery provider: xyz')
  end
end
