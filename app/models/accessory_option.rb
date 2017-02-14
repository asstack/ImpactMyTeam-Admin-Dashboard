class AccessoryOption < ActiveRecord::Base
  belongs_to :primary, class_name: 'ProductVariant'
  belongs_to :accessory, class_name: 'Product'

  attr_accessible :exclusive, :primary_id, :accessory_id

  validates :accessory_id, uniqueness: { scope: :primary_id }
end
