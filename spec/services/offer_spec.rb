# frozen_string_literal: true

RSpec.describe Offer do
  let(:basket) { instance_double('Basket') }

  it "delegates to the 'rhp' offer calculator" do
    offer = Offer.new(basket: basket, offer: 'rhp')

    calculator = instance_double('OfferCalculators::RedSecondHalfPrice', apply: true)
    expect(OfferCalculators::RedSecondHalfPrice).to receive(:new).with(basket: basket).and_return(calculator)
    expect(offer.apply).to be_truthy
  end

  it 'raises error when offer is unknown' do
    offer = Offer.new(basket: basket, offer: 'unknown')

    expect { offer.apply }.to raise_error(Offer::Error, 'Unknown offer: unknown')
  end
end
