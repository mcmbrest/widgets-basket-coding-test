# frozen_string_literal: true

RSpec.describe OfferCalculators::RedSecondHalfPrice do
  let(:price) { 32.95 }
  let(:red_widget) { instance_double('Product', code: 'R01', price: price) }

  def basket_with_items(items)
    instance_double('Basket', items: items)
  end

  it 'does nothing when there is no Red Widget in the basket' do
    item_other = BasketItem.new(product: instance_double('Product', code: 'G01', price: 24.95), quantity: 2)
    basket = basket_with_items([item_other])

    calculator = described_class.new(basket: basket)

    expect { calculator.apply }.not_to change { item_other.discounted_amount }
  end

  it 'does nothing when there is only one Red Widget' do
    red_item = BasketItem.new(product: red_widget, quantity: 1)
    basket = basket_with_items([red_item])

    calculator = described_class.new(basket: basket)
    calculator.apply

    expect(red_item.discounted_amount).to be_nil
    expect(red_item.applied_offers).to eq([])
  end

  it 'applies 50% discount to every second Red Widget (quantity 2)' do
    red_item = BasketItem.new(product: red_widget, quantity: 2)
    basket = basket_with_items([red_item])

    calculator = described_class.new(basket: basket)
    calculator.apply

    expected_amount = (price + (price / 2).round(2))
    expect(red_item.discounted_amount).to eq(expected_amount)
    expect(red_item.applied_offers).to include('rhp')
  end

  it 'applies correctly for odd quantities (quantity 3)' do
    red_item = BasketItem.new(product: red_widget, quantity: 3)
    basket = basket_with_items([red_item])

    described_class.new(basket: basket).apply

    expected_amount = price + (price / 2).round(2) + price
    expect(red_item.discounted_amount).to eq(expected_amount)
    expect(red_item.applied_offers).to include('rhp')
  end

  it 'applies 50% discount to every second Red Widget (quantity 4)' do
    red_item = BasketItem.new(product: red_widget, quantity: 4)
    basket = basket_with_items([red_item])

    calculator = described_class.new(basket: basket)
    calculator.apply

    expected_amount = (price + (price / 2).round(2) + price + (price / 2).round(2))
    expect(red_item.discounted_amount).to eq(expected_amount)
    expect(red_item.applied_offers).to include('rhp')
  end
end
