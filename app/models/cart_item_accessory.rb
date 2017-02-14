class CartItemAccessory < ActiveRecord::Base
  belongs_to :cart_item
  belongs_to :accessory, class_name: 'ProductVariant'
end
