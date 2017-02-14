require 'spec_helper'

describe CartItemAccessory do
  specify { Fabricate(:cart_item_accessory).should be_persisted }
  it { should belong_to(:cart_item) }
  it { should belong_to(:accessory).class_name('ProductVariant') }
end
