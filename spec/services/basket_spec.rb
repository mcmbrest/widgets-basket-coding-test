# frozen_string_literal: true

RSpec.describe Basket do
  let(:product_r01) { instance_double('Product', code: 'R01', price: 32.95) }
  let(:product_g01) { instance_double('Product', code: 'G01', price: 24.95) }
  let(:product_b01) { instance_double('Product', code: 'B01', price: 7.95) }

  describe '#add_item' do
    context 'when item does not exist in basket' do
      it 'creates a new basket item and applies offers' do
        allow(Product).to receive(:find_by).with(code: 'R01').and_return(product_r01)

        fake_offer = instance_double('Offer', apply: true)
        expect(Offer).to receive(:new).with(basket: instance_of(Basket), offer: anything).at_least(:once).and_return(fake_offer)

        basket = Basket.new(offers: ['rhp'])
        items = basket.add_item('R01')

        expect(items.size).to eq(1)
        expect(items.first).to be_a(BasketItem)
        expect(items.first.product).to eq(product_r01)
      end

      it 'raises Basket::Error when product is not found' do
        allow(Product).to receive(:find_by).with(code: 'X01').and_return(nil)

        basket = Basket.new
        expect { basket.add_item('X01') }.to raise_error(Basket::Error, 'Product not found')
      end
    end

    context 'when item already exists in basket' do
      it 'increments quantity' do
        allow(Product).to receive(:find_by).with(code: 'R01').and_return(product_r01)

        basket = Basket.new
        basket.add_item('R01')
        basket.add_item('R01')

        expect(basket.items.first.quantity).to eq(2)
      end
    end
  end

  describe '#add_offer' do
    it 'adds a unique offer and applies offers' do
      basket = Basket.new
      fake_offer = instance_double('Offer', apply: true)
      expect(Offer).to receive(:new).with(basket: basket, offer: 'rhp').and_return(fake_offer)

      offers = basket.add_offer('rhp')
      expect(offers).to eq(['rhp'])

      # adding again should not duplicate
      expect(Offer).to receive(:new).with(basket: basket, offer: 'rhp').and_return(fake_offer)
      offers = basket.add_offer('rhp')
      expect(offers).to eq(['rhp'])
    end
  end

  describe '#total' do
    it 'sums basket_amounts and adds delivery cost' do
      basket = Basket.new(delivery_provider: 'default')
      item1 = instance_double('BasketItem', basket_amount: 10.00)
      item2 = instance_double('BasketItem', basket_amount: 20.50)
      allow(basket).to receive(:items).and_return([item1, item2])

      expect(basket.total).to eq(((10.00 + 20.50) + 4.95).round(2))
    end

    context 'with different product combinations' do
      before do
        allow(Product).to receive(:find_by).with(code: 'R01').and_return(product_r01)
        allow(Product).to receive(:find_by).with(code: 'G01').and_return(product_g01)
        allow(Product).to receive(:find_by).with(code: 'B01').and_return(product_b01)
      end

      it 'calculates total for B01, G01' do
        basket = Basket.new(delivery_provider: 'default', offers: ['rhp'])
        basket.add_item('B01')
        basket.add_item('G01')

        expect(basket.total).to eq(37.85)
      end

      it 'calculates total for R01, R01 with offer' do
        basket = Basket.new(delivery_provider: 'default', offers: ['rhp'])
        2.times { basket.add_item('R01') }

        expect(basket.total).to eq(54.38)
      end

      it 'calculates total for R01, R01, R01, R01 with offer' do
        basket = Basket.new(delivery_provider: 'default', offers: ['rhp'])
        4.times { basket.add_item('R01') }

        expect(basket.total).to eq(98.86)
      end

      it 'calculates total for R01, G01' do
        basket = Basket.new(delivery_provider: 'default', offers: ['rhp'])
        basket.add_item('R01')
        basket.add_item('G01')

        expect(basket.total).to eq(60.85)
      end

      it 'calculates total for B01, B01, R01, R01, R01 with offer' do
        basket = Basket.new(delivery_provider: 'default', offers: ['rhp'])
        2.times { basket.add_item('B01') }
        3.times { basket.add_item('R01') }

        expect(basket.total).to eq(98.28)
      end
    end
  end
end
