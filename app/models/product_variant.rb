class ProductVariant < ActiveRecord::Base
  belongs_to :product

  has_many :color_options, dependent: :destroy
  has_many :product_colors, through: :color_options

  # Accessory Products
  has_many :accessory_options,
            foreign_key:  :primary_id,
            dependent:    :destroy

  has_many :accessories,
            through:      :accessory_options,
            class_name:   'Product'

  accepts_nested_attributes_for :accessory_options,
                                allow_destroy: true,
                                reject_if: proc { |attr| attr['accessory_id'].blank? }

  mount_uploader :image, ImageUploader

  attr_accessible :configuration, :custom_graphic_price, :item_code, :price,
                  :default, :configuration_notes, :product_color_ids,
                  :accessory_options_attributes, :image, :image_cache, :remove_image

  scope :default, where(default: true)

  def name
    [product.name, configuration].join(' - ')
  end
end
