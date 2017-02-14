require 'spec_helper'

describe Product do
  it { should have_many(:variants).class_name('ProductVariant').dependent(:destroy) }


  it { should have_many(:primary_options).class_name('AccessoryOption').dependent(:destroy) }
  it { should have_many(:primaries).through(:primary_options).class_name('ProductVariant') }
end
