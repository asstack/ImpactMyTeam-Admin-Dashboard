require 'spec_helper'

describe ColorOption do
  it { should belong_to :product_variant }
  it { should belong_to :product_color }
end
