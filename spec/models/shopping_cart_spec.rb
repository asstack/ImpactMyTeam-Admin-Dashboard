require 'spec_helper'

describe ShoppingCart do
  specify { Fabricate(:shopping_cart).should be_persisted }
  it { should belong_to :campaign }
  it { should have_many(:items).class_name('CartItem').dependent(:destroy) }

  describe '#calculate_subtotal' do
    let(:cart) { Fabricate(:shopping_cart) }
    let(:item_a) { Fabricate(:cart_item, subtotal: 10.99) }
    let(:item_b) { Fabricate(:cart_item, subtotal: 5.99) }

    it 'sums the item subtotals' do
      cart.items << item_a
      cart.items << item_b

      cart.calculate_subtotal.should == 16.98
    end
  end

  describe '#calculate_subtotal!' do
    let(:cart) { Fabricate(:shopping_cart) }
    let(:item_a) { Fabricate(:cart_item, subtotal: 10.99) }
    let(:item_b) { Fabricate(:cart_item, subtotal: 5.99) }

    it 'sums the item subtotals' do
      cart.items << item_a
      cart.items << item_b

      cart.calculate_subtotal!
      cart.reload.subtotal.should == 16.98
    end
  end

  describe '#calculate_fees' do
    let(:cart) { Fabricate(:shopping_cart) }
    let(:item_a) { Fabricate(:cart_item, subtotal: 1500.99) }
    let(:item_b) { Fabricate(:cart_item, subtotal: 25.99) }

    it 'calculates the fees at 5% and rounds the total (subtotal+fees) to nearest $5' do
      cart.items << item_a
      cart.items << item_b

      cart.calculate_fees.should == 78.02
    end
  end

  describe '#calculate_fees!' do
    let(:cart) { Fabricate(:shopping_cart) }
    let(:item_a) { Fabricate(:cart_item, subtotal: 1500.99) }
    let(:item_b) { Fabricate(:cart_item, subtotal: 25.99) }

    it 'calculates the fees at 5% and rounds the total (subtotal+fees) to nearest $5' do
      cart.items << item_a
      cart.items << item_b

      cart.calculate_fees!
      cart.reload.fees.should == 78.02
    end
  end

  describe '#calculate_order_total' do
    let(:cart) { Fabricate(:shopping_cart) }
    let(:item_a) { Fabricate(:cart_item, subtotal: 1500.99) }
    let(:item_b) { Fabricate(:cart_item, subtotal: 25.99) }

    it 'calculates the fees at 5% and rounds the total (subtotal+fees) to nearest $5' do
      cart.items << item_a
      cart.items << item_b

      cart.calculate_order_total.should == 1605.00
    end
  end

  describe '#calculate_order_total!' do

    let(:cart) { Fabricate(:shopping_cart) }
    let(:item_a) { Fabricate(:cart_item, subtotal: 1500.99) }
    let(:item_b) { Fabricate(:cart_item, subtotal: 25.99) }

    it 'writes the fees and subtotal to nearest $5' do
      cart.items << item_a
      cart.items << item_b

      cart.calculate_order_total!
      cart.reload
      cart.subtotal.should == 1526.98
      cart.fees.should == 78.02
      cart.order_total.should == 1605.00
    end
  end

  describe '#order_total' do
    let(:cart) { Fabricate(:shopping_cart, subtotal: 20.00, fees: 10.00, taxes: 5.00, shipping: 3.00) }

    it 'sums the subtotal, fees, taxes, and shipping costs' do
      cart.order_total.should == 38.00
    end
  end
end
