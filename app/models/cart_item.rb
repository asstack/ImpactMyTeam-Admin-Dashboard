class CartItem < ActiveRecord::Base
  belongs_to :shopping_cart
  belongs_to :product_variant
  belongs_to :product_color

  has_many :cart_item_accessories, dependent: :destroy
  has_many :accessories, through: :cart_item_accessories, class_name: 'ProductVariant'

  mount_uploader :custom_product_image, ImageUploader
  mount_uploader :custom_graphic, VectorImageUploader

  attr_accessible :subtotal, :quantity, :product_variant_id, :product_color_id, :accessory_ids,
                  :custom_product_image, :custom_product_image_cache, :remove_custom_product_image,
                  :custom_graphic, :custom_graphic_cache, :remove_custom_graphic

  delegate :product, :price, :configuration, :custom_graphic_price, :name, :color_options, :accessory_options, to: :product_variant
  delegate :name, :summary, to: :product, prefix: :product
  delegate :campaign, to: :shopping_cart

  validates :quantity, numericality: { greater_than: 0 }

  def calculate_subtotal
    single_item_total = product_variant.price + accessories.sum(&:price)
    single_item_total += custom_graphic_price if custom_graphic?
    single_item_total * quantity
  end

  def calculate_subtotal!
    self.update_attributes(subtotal: calculate_subtotal)
  end

  def image
    custom_product_image.presence || color_options.with_color(product_color).first.try(:image) || product_variant.image
  end

  def allow_custom_graphic?
    custom_graphic_price && custom_graphic_price > 0.00
  end
end
