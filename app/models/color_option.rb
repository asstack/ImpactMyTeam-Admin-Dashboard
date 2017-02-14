class ColorOption < ActiveRecord::Base
  belongs_to :product_variant
  belongs_to :product_color

  mount_uploader :image, ImageUploader

  attr_accessible :image, :image_cache, :remove_image

  delegate :name, to: :product_color

  scope :with_color, lambda{ |color| where(product_color_id: (color ? color.id : 0)) }
end
