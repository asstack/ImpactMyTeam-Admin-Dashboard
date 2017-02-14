require 'spec_helper'

describe ProductVariant do
  it { should belong_to :product }
  it { should have_many(:color_options).dependent(:destroy) }
  it { should have_many(:product_colors).through(:color_options) }

  it { should have_many(:accessory_options).dependent(:destroy) }
  it { should have_many(:accessories).through(:accessory_options).class_name('Product') }
end
