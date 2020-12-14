require 'spec_helper'
require 'checkout'

RSpec.describe Checkout do
  let(:checkout) { Checkout.new }

  describe '#scan' do
    let(:basket) { checkout.basket }
    context 'when item is not found' do
      it 'returns item not found exception' do
        scan_response = checkout.scan('grapefruit')

        expect(scan_response.class).to eq(IOError)
        expect(scan_response.message).to eq('Item not found.')
      end
    end

    context 'when one item is successfully added to basket' do
      before do
        checkout.scan('apple')
      end

      it 'returns item count in basket of one' do
        expect(basket.length).to eq(1)
      end
    end

    context 'when five items are successfully added to basket' do
      before do
        checkout.scan('apple')
        checkout.scan('pear')
        checkout.scan('mango')
        2.times { checkout.scan('pineapple') }
      end

      it 'returns item count in basket of five' do
        item_count = 0
        basket.each do |item|
          item_count += item[:count]
        end

        expect(item_count).to eq(5)
      end
    end

    context 'when attempting to add five items to basket but one is not found' do
      before do
        checkout.scan('apple')
        checkout.scan('grapefruit')
        checkout.scan('mango')
        2.times { checkout.scan('pineapple') }
      end

      it 'returns item count in basket of 4' do
        item_count = 0
        basket.each do |item|
          item_count += item[:count]
        end

        expect(item_count).to eq(4)
      end
    end
  end

  describe '#total' do
    subject(:total) { checkout.total }

    context 'when no offers apply' do
      before do
        checkout.scan('apple')
        checkout.scan('orange')
      end

      it 'returns the base price for the basket' do
        expect(total).to eq(30)
      end
    end

    context 'when a two for 1 applies on apples' do
      before do
        2.times { checkout.scan('apple') }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(10)
      end

      context 'and there are other items' do
        before do
          checkout.scan('orange')
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a two for 1 applies on pears' do
      before do
        2.times { checkout.scan('pear') }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end

      context 'and there are other discounted items' do
        before do
          checkout.scan('banana')
        end

        it 'returns the correctly discounted price for the basket' do
          expect(total).to eq(30)
        end
      end
    end

    context 'when a half price offer applies on bananas' do
      before do
        checkout.scan('banana')
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(15)
      end
    end

    context 'when a half price offer applies on pineapples restricted to 1 per customer' do
      before do
        checkout.scan('pineapple')
        checkout.scan('pineapple')
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(150)
      end
    end

    context 'when a buy 3 get 1 free offer applies to mangos' do
      before do
        4.times { checkout.scan('mango') }
      end

      it 'returns the discounted price for the basket' do
        expect(total).to eq(600)
      end
    end
  end
end
