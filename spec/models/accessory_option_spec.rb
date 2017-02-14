require 'spec_helper'

describe AccessoryOption do
  it { should belong_to(:primary).class_name('ProductVariant') }
  it { should belong_to(:accessory).class_name('Product') }
  it { should allow_mass_assignment_of(:accessory_id) }
  it { should allow_mass_assignment_of(:primary_id) }

  it { should validate_uniqueness_of(:accessory_id).scoped_to(:primary_id) }
end
