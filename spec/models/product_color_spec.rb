require 'spec_helper'

describe ProductColor do
  specify { Fabricate(:product_color).should be_persisted }
end
