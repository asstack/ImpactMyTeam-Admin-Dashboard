class Product < ActiveRecord::Base
  scope :in_catalog, where(show_in_catalog: true)

  has_many :variants,
            class_name: 'ProductVariant',
            dependent: :destroy

  has_many :primary_options,
            class_name: 'AccessoryOption',
            foreign_key: :accessory_id,
            dependent: :destroy

  has_many :primaries,
            through: :primary_options,
            class_name: 'ProductVariant'

  attr_accessible :description, :name, :summary, :show_in_catalog
end
