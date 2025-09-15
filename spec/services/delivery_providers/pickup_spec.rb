# frozen_string_literal: true

RSpec.describe DeliveryProviders::Pickup do
  let(:basket) { instance_double('Basket') }

  it 'always returns 0.0' do
    provider = described_class.new(basket: basket)

    expect(provider.calculate).to eq(0.0)
  end
end
