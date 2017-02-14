require 'spec_helper'

describe CartItem do
  specify { Fabricate(:cart_item, quantity: 1).should be_persisted }

  it { should belong_to(:shopping_cart) }
  it { should belong_to(:product_color) }
  it { should belong_to(:product_variant) }

  it { should have_many(:cart_item_accessories).dependent(:destroy) }
  it { should have_many(:accessories).through(:cart_item_accessories).class_name('ProductVariant') }

  describe 'delegated methods' do
    %i(product custom_graphic_price name color_options accessory_options).each do |method|
      it "delegates ##{method} to #product_variant"
    end

    %i(price).each do |method|
      it "delegates ##{method} to #product_variant as #variant_#{method}"
    end

    %i(campaign).each do |method|
      it "delegates ##{method} to #shopping_cart"
    end
  end

  describe '#calculate_subtotal' do
    let(:cart_item) { Fabricate(:cart_item, product_variant: variant, product_color: color, quantity: quantity) }
    let(:variant) { Fabricate(:product_variant, price: 10.99) }
    let(:color) { Fabricate(:product_color) }

    let(:accessory_a) { Fabricate(:product_variant, price: 12.00) }
    let(:accessory_b) { Fabricate(:product_variant, price: 3.00) }

    context 'with quantity 1' do
      let(:quantity) { 1 }
      it 'returns the cost of the product variant when quantity is 1' do
        cart_item.calculate_subtotal.should == 10.99
      end

      it 'adds the cost of accessory items' do
        cart_item.accessories << accessory_a
        cart_item.accessories << accessory_b

        cart_item.calculate_subtotal.should == 25.99
      end

      context 'with a custom graphic' do
        before do
          CartItem.any_instance.stub(custom_graphic?: true, custom_graphic_price: 180.00)
        end

        it 'adds the cost of the graphic' do
          cart_item.calculate_subtotal.should == 190.99
        end
      end
    end

    context 'with quantity 3' do
      let(:quantity) { 3 }

      it 'returns the cost multiplied by the quantity' do
        cart_item.calculate_subtotal.should == 32.97
      end

      it 'multiplies accessory costs with item quantity' do
        cart_item.accessories << accessory_a
        cart_item.accessories << accessory_b

        cart_item.calculate_subtotal.should == 77.97
      end

      context 'with a custom graphic' do
        before do
          CartItem.any_instance.stub(custom_graphic?: true, custom_graphic_price: 180.00)
        end

        it 'multiplies the cost of the graphic with item quantity' do
          cart_item.calculate_subtotal.should == 572.97
        end
      end
    end
  end

  describe '#calculate_subtotal!' do
    let(:cart_item) { Fabricate(:cart_item, product_variant: variant, product_color: color, quantity: quantity) }
    let(:variant) { Fabricate(:product_variant, price: 10.99) }
    let(:color) { Fabricate(:product_color) }

    let(:accessory_a) { Fabricate(:product_variant, price: 12.00) }
    let(:accessory_b) { Fabricate(:product_variant, price: 3.00) }

    context 'with quantity 1' do
      let(:quantity) { 1 }
      it 'returns the cost of the product variant when quantity is 1' do
        cart_item.calculate_subtotal!
        cart_item.reload.subtotal.should == 10.99
      end

      it 'adds the cost of accessory items' do
        cart_item.accessories << accessory_a
        cart_item.accessories << accessory_b

        cart_item.calculate_subtotal!
        cart_item.reload.subtotal.should == 25.99
      end

      context 'with a custom graphic' do
        before do
          CartItem.any_instance.stub(custom_graphic?: true, custom_graphic_price: 180.00)
        end

        it 'adds the cost of the graphic' do
          cart_item.calculate_subtotal!
          cart_item.reload.subtotal.should == 190.99
        end
      end
    end

    context 'with quantity 3' do
      let(:quantity) { 3 }

      it 'returns the cost multiplied by the quantity' do
        cart_item.calculate_subtotal!
        cart_item.reload.subtotal.should == 32.97
      end

      it 'multiplies accessory costs with item quantity' do
        cart_item.accessories << accessory_a
        cart_item.accessories << accessory_b

        cart_item.calculate_subtotal!
        cart_item.reload.subtotal.should == 77.97
      end

      context 'with a custom graphic' do
        before do
          CartItem.any_instance.stub(custom_graphic?: true, custom_graphic_price: 180.00)
        end

        it 'multiplies the cost of the graphic with item quantity' do
          cart_item.calculate_subtotal!
          cart_item.reload.subtotal.should == 572.97
        end
      end
    end
  end
end
