# frozen_string_literal: true

RSpec.describe BasketItem do
  let(:product) { instance_double('Product', price: 12.34, code: 'X01') }

  it 'initializes with quantity 1 by default and calculates amount' do
    item = BasketItem.new(product: product)

    expect(item).to have_attributes(
      quantity: 1,
      amount: 12.34,
      basket_amount: 12.34,
      applied_offers: [],
      discounted_amount: nil
    )
  end

  it 'respects custom quantity and calculates amount' do
    item = BasketItem.new(product: product, quantity: 3)

    expect(item.amount).to eq(12.34 * 3)
  end

  it 'applies offer only once and sets discounted amount' do
    item = BasketItem.new(product: product, quantity: 2)

    item.add_offer(offer: 'rhp', discounted_amount: 10.0)

    expect(item).to have_attributes(
      basket_amount: 10.0,
      applied_offers: ['rhp']
    )

    # adding same offer again should not duplicate
    item.add_offer(offer: 'rhp', discounted_amount: 8.0)

    expect(item).to have_attributes(
      basket_amount: 8.0,
      applied_offers: ['rhp']
    )
  end
end
